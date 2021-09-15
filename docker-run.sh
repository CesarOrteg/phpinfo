#!/bin/sh

git clone https://github.com/CesarOrteg/phpinfo
cd phpinfo
git checkout 2021-09-cesar

docker image build \
  --file ./Dockerfile \
  --no-cache \
  --tag local/phpinfo:test \
  ./

docker network create phpinfo-net
docker container run \
  --detach \
  --name phpinfo-cont \
  --network phpinfo-net \
  --read-only \     #Container is RO
  --restart always \
  --user nobody \     #User launching the container
  --volume ./src/:/app/:ro \    #Volume is RO
  --workdir /app \
  local/phpinfo:test
