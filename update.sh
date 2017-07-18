#!/bin/bash

docker build -t site-max .

docker stop some-nginx
docker rm some-nginx

docker run --name some-nginx -d -p 80:80 site-max
