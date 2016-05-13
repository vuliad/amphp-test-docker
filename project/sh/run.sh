#!/bin/bash
cd /srv/project/ && composer update
cd /srv/project/ && vendor/bin/aerys -c aerys_config.php -w 1