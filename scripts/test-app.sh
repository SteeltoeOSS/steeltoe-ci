#!/usr/bin/env bash
set -ex

export URL=`cat cf-push/url`

if [ ! -z "$PRECOND" ]; then
  eval $PRECOND
fi

if [[ `curl -k https://${URL}${URL_PATH}` == *"${TEXT}"* ]]; then
  echo "Found $TEXT"
else
  exit 1
fi
