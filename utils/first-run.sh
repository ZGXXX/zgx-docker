#!/usr/bin/env bash

set -euo pipefail

projects=(common admin activity monitor union-adtrace union-user oa union-base union-order web union-adpage union-data union-packtool union-gate)

cd $(dirname "${BASH_SOURCE[0]}")/..

echo Create RabbitMQ queues
docker-compose exec shell71 sh -c "cd /data/init && composer install && php script/union_queue_init.php"

echo Sync env to zookeeper
docker-compose exec shell71 php /data/init/script/env_sync.php all

echo Create database
docker-compose exec shell71 bash -c "grep DATABASE= /data/init/data/env/*.env | awk -F= '{print \$2}' | xargs -I DB mysql -hmysql -uroot -proot -e 'create database if not exists DB'"

echo Create missing config files
for i in "${projects[@]}"
do
    docker-compose exec shell71 bash -c "echo '<?php return [];' > /data/web/$i/www/config/wdnodes.php; echo '<?php return [];' > /data/web/$i/www/config/wdservices.php"
done

echo Composer
for i in "${projects[@]}"
do
    echo "Install packages for project $i:"
    docker-compose exec shell71 sh -c "cd /data/web/$i/www/; composer install"
done

echo Run database migration
for i in "${projects[@]}"
do
    echo "Run database migration project $i:"
    docker-compose exec shell71 php /data/web/$i/www/artisan migrate || true
done

echo Publis unionconst
docker-compose exec shell71 php /data/web/common/www/artisan zkpush:push unionconst

echo Publish Services
for i in "${projects[@]}"
do
    echo "Publish services of project $i"
    docker-compose exec shell71 php /data/web/$i/www/artisan zkpush:push myservice || true
done

docker-compose ps | grep zk | awk -F_ '{print $2}' | xargs docker-compose restart

echo Admin html (TODO: git submodule)
docker-compose exec shell71 bash -c  "cd /data/web/admin/www/public; rmdir static; git clone git@mygit.ihdmobi.com:wdtech-server/admin-html.git static"

echo TODO: Run database seeder for every project
