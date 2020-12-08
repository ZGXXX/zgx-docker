#!/usr/bin/env bash

set -euo pipefail

projects=(admin init activity monitor union-adtrace union-user oa union-base union-order web common union-adpage union-data union-packtool wdlib union-gate)

cd $(dirname "${BASH_SOURCE[0]}")/..

echo "Clone source code"
cd ..
# Auto generated
for i in "${projects[@]}"
do
    if [[ ! -d $i ]]; then
	git clone git@mygit.ihdmobi.com:wdtech-server/$i.git
    else
	echo Project $i exists, skip cloning
    fi
done
cd -

echo "Build PHP images"
bash ./images/php71/build-images.sh

echo "Copy config and .env"
cp ./data/env_file/*.env ../init/data/env/
cp ./data/config/global.php ../init/config/global.php

echo "Finish"
