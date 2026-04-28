#!/bin/sh
set -eu

docker build -t badass-host:latest ./host-image
docker build -t badass-router:latest ./router-image
