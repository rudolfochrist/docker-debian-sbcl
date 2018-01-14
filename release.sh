#!/bin/sh

# Ref.: https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

set -e
USERNAME=rudolfochrist
IMAGE=debian-sbcl

# Get latest changes
git checkout master
git pull

# Bump version
version=$(perl -pe 's/b(\d)+/b.($1+1)/e' < version)
echo $version > version

# run build
./build.sh

# Tag release
git add -A
git commit -m "Release $version"
git tag -s $version -m "Release $version"
git push
git push --tags

# Tag docker image
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# Push image
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
