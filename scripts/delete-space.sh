#!/usr/bin/env bash
set -ex

./cf-space/login

# Delete all apps in space
cf apps | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf delete -f

# Delete all services in space
cf services | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf delete-service -f

# Purge all services in space
cf services | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf purge-service-instance -f

# Delete space
export SPACE=`cat cf-space/name`
cf delete-space -f $SPACE
