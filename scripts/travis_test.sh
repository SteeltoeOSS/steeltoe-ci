#!/bin/bash
if [[! $TestFrameworkVersion ]]
    export TestFrameworkVersion="netcoreapp2.0"
fi

# Run unit tests
for d in ./test/*.Test; do
    cd $d
    echo "Running tests in $d"
    dotnet restore
	# use dotnet test until dotnet xunit works on netcoreapp2.1
    # dotnet xunit -verbose -framework netcoreapp2.0
    dotnet test -v d -f $TestFrameworkVersion
    cd ../../
done

if [[ $? != 0 ]]; then exit 1 ; fi