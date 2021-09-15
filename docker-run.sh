#!/bin/sh

git clone https://github.com/CesarOrteg/phpinfo
cd phpinfo
git checkout 2021-09-cesar

docker image build \
  --file ./Dockerfile \
  --no-cache \
  --tag local/phpinfo:test \
  ./

#Testing the image
#docker container run --entrypoint /bin/sh --interactive --rm --tty local/phpinfo:test
#which php

docker network create phpinfo-net
docker container run \
  --cpus '0.1' \
  --detach \
  --env AUTHOR=me \
  --label app=phpinfo \
  --memory 100M \
  --name phpinfo-cont \
  --network phpinfo-net \
  --publish 80:8080 \
  #Container is RO
  --read-only \     
  --restart always \
  #User launching the container
  --user nobody \
  #Volume is RO
  --volume ${PWD}/src/:/app/:ro \    
  --workdir /app \
  local/phpinfo:test
  -f /src/index.php \
  -S 0.0.0.0:8080
