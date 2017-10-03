##!/usr/bin/env bash
#
#for file in pipelines/*.yml; do
#  base=$(basename $file .yml)
#  echo $base
#  fly -t shoetree set-pipeline -l <(lpass show --notes 'Shared-Steeltoe/concourse.yml') -p $base -c $file
#done
