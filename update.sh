#!/usr/bin/env bash

basedir=$(dirname $0)
for file in $basedir/pipelines/*.yml; do
  base=$(basename $file .yml)
  echo $base
  fly -t steeltoe set-pipeline -l <(lpass show --notes 'Shared-Steeltoe/concourse.yml') -p $base -c $file
done
