#!/bin/bash

docker build . -t lnd
docker tag lnd:latest kilrau/lnd:0.11.1-beta
docker push kilrau/lnd:0.11.1-beta
