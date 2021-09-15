#!/bin/sh

git clone https://https://github.com/CesarOrteg/phpinfo
cd phpinfo
git checkout 2021-09-cesar

docker image build \
  --file src/Dockerfile \
  --tag local/phpinfo:test

docker network create phpinfo-net
docker container run \
  --detach \
  --name phpinfo-cont \
  --network phpinfo-net \
  --read-only \     #Container is RO
  --restart always \
  --volume src/:/src/:ro \    #Volume is RO
  local/phpinfo:test
