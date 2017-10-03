#!/usr/bin/env bash

basedir=$(dirname $0)
for dfile in $basedir/dockerfiles/*/Dockerfile; do
    name=$(basename $(dirname $dfile))
    docker build -t steeltoeoss/$name $basedir/dockerfiles/$name || exit
    docker push steeltoeoss/$name || exit
done
