#!/bin/bash

docker build . -t bitcoind
docker tag bitcoind:latest kilrau/bitcoind:latest
docker push kilrau/bitcoind:latest
#docker run --rm -it bitcoind
