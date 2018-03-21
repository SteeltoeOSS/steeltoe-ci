#!/bin/bash   

dotnet --info

export CI_BUILD=True
if [[ "$TRAVIS_BRANCH" == "master" ]]; 
then 
	echo "Use dependencies from nuget.org and myget/master"
	export MyGet_Feed="steeltoemaster"
elif [[ "$TRAVIS_BRANCH" == "dev" ]]; 
then 
	echo "Use dependencies from nuget.org and myget/dev"
	export MyGet_Feed="steeltoedev"
elif [[ "${TRAVIS_BRANCH:0:6}" == "update" ]]; 
then 
	echo "Use dependencies from nuget.org and myget/update"
	export MyGet_Feed="steeltoestaging"
else
    echo "No special case detected, just use nuget.org"
fi

if [[ $MyGet_Feed ]];
then
	# write out a nuget config file
	cat > nuget.config <<EOF 
<?xml version="1.0" encoding="utf-8"?>
<configuration>
<packageSources>
	<add key="Steeltoe" value="https://www.myget.org/F/$MyGet_Feed/api/v3/index.json" />
	<add key="NuGet" value="https://api.nuget.org/v3/index.json" />
</packageSources>
</configuration>
EOF
fi