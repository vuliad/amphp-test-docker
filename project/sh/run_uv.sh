#!/bin/bash
echo "extension = uv.so" > /etc/php/7.0/cli/conf.d/20-uv.ini
/bin/bash /srv/project/sh/run.sh