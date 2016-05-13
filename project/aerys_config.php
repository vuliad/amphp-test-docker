<?php
$redis = new Amp\Redis\Client("tcp://127.0.0.1:6379");

$redis->set("foobar", str_repeat("a", 1024 * 1024 * 16));

echo "RUNNING".PHP_EOL;
(new Aerys\Host)->use(
    function (\Aerys\Request $req, \Aerys\Response $res) use ($redis) {
        $res->setHeader('Content-type', 'text/plain');
        $start = microtime(true);
        $readedData = yield $redis->get("foobar");
        yield $res->stream('strlen: ' . strlen($readedData) . PHP_EOL);
        yield $res->stream('Time(s): ' . (microtime(true) - $start) . PHP_EOL);
        yield $res->stream('Memory(mb): ' . (memory_get_usage() / 1024 / 1024));
        $res->end();
    }
)->expose("0.0.0.0", 1337);