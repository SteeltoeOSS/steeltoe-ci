##!/usr/bin/env bash
#set -eux
#
#./cf-space/login
#export SPACE=`cat cf-space/name`
#export DATA=`cf curl "/v2/spaces?q=name%3A${SPACE}&inline-relations-depth=2" | jq '.resources[].entity|{apps:.apps|map(.entity.name), services:.service_instances|map(.entity.name)}'`
#
#for app in `echo $DATA | jq -r '.apps[]'`; do
#  cf delete -f $app
#done
#
#for service in `echo $DATA | jq -r '.services[]'`; do
#  cf delete-service -f $service
#done
#
#for service in `echo $DATA | jq -r '.services[]'`; do
#  cf purge-service-instance -f $service | true
#done
#
#cf delete-space -f $SPACE
