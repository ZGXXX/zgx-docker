:#!/usr/bin/env bash

set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

docker build -f base.Dockerfile -t zgx-php-base:7.3 .

# docker build -f shell.Dockerfile -t union-php-shell:7.1 .

# docker build -f xdebug.Dockerfile -t union-php-xdebug:7.1 --build-arg REMOTE_HOST=$host .
