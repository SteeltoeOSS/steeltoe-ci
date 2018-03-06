#!/bin/bash

# Run unit tests
for d in ./test/*.Test; do
    cd $d
    dotnet restore
    dotnet xunit -verbose -framework netcoreapp2.0
    cd ../../
done

if [[ $? != 0 ]]; then exit 1 ; fi