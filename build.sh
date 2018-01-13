#!/bin/sh

set -e
USERNAME=rudolfochrist
IMAGE=debian-sbcl

docker build -t $USERNAME/$IMAGE:latest .
