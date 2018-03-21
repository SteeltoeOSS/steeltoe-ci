Set-Location src
If ($env:ProjectList -eq $null){
	Write-Host "env:ProjectList was not defined - discover and build projects alphabetically"
	$env:ProjectList = Get-ChildItem -Directory 
}
# build each project in the src folder
ForEach ($_ in $env:ProjectList.Split(' ')) {
	Write-Host "Now building $_..."
	Set-Location $_

	dotnet restore

	# if there is a tag with the latest commit don't include symbols or source
	If ($env:APPVEYOR_REPO_TAG_NAME)
	{
		Write-Host "Creating package $_.$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX without symbols"
		dotnet pack --configuration $env:BUILD_TYPE /p:Version=$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX -o $env:APPVEYOR_BUILD_FOLDER\localfeed
	}
	Else
	{
		Write-Host "Creating package $_.$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX with symbols"
		# include symbols and source
		dotnet pack --configuration $env:BUILD_TYPE /p:Version=$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX --include-symbols --include-source -o $env:APPVEYOR_BUILD_FOLDER\localfeed
	}
	Set-Location ..
}
Set-Location ..