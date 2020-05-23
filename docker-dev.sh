#!/bin/sh

docker build -t hex7-dev \
	     -f Dockerfile \
	     --build-arg "DATE=$(date)" \
	     --build-arg "REVISION=$(git rev-parse HEAD)" \
	     .

docker kill hex7-dev 2> /dev/null || true
sleep 2

docker run --rm \
           --name hex7-dev \
	   -d \
	   -p 8000:8000 \
           hex7-dev
