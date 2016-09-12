#! /usr/bin/env bash

export CREDENTIAL_FILTER_WHITELIST="HOME,TMPDIR,PWD,LANGUAGE,TERM,USER,LANG,SHLVL,OLDPWD"

exec &> >(concourse-filter)
