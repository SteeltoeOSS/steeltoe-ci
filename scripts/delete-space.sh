#!/usr/bin/env bash
set -ex

./cf-space/login

# Purge all services in space
cf services | sed '1,4d' | cut -d ' ' -f 1 | xargs -n1 cf purge-service-instance -f

# Delete space
cf delete-space -f `cat cf-space/name`

