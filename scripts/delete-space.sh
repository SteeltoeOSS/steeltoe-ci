#!/usr/bin/env bash
set -ex

./cf-space/login

# Deleet all services in space
cf services | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf delete-service -f

# Purge all services in space
cf services | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf purge-service-instance -f

# Delete space
export SPACE=`cat cf-space/name`
cf delete-space -f $SPACE
