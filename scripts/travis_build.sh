#!/bin/bash

# loop through projects, restore & build
for d in ./src/*; do
    cd $d
    dotnet restore
    dotnet build --f netcoreapp2.0
    cd ../../
done
