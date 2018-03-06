dotnet build --configuration $env:BUILD_TYPE

# package each project in the src folder
Set-Location src
ForEach ($_ in Get-ChildItem -Directory) {
	Write-Host "Now building $_..."
	Set-Location $_

	# if there is a tag with the latest commit don't include symbols or source
	If ($env:APPVEYOR_REPO_TAG_NAME)
	{
		Write-Host "Creating package $_.$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX without symbols"
		dotnet pack --no-build --configuration $env:BUILD_TYPE /p:Version=$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX
	}
	Else
	{
		Write-Host "Creating package $_.$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX with symbols"
		# include symbols and source
		dotnet pack --no-build --configuration $env:BUILD_TYPE /p:Version=$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX --include-symbols --include-source
	}
	# send package to local feed for use within this build
	Write-Host "Adding package to local feed for use within this build..."
	nuget add bin\$env:BUILD_TYPE\$_.$env:STEELTOE_VERSION$env:STEELTOE_DASH_VERSION_SUFFIX.nupkg -Source "$env:USERPROFILE\localfeed"

	Set-Location ..
}
Set-Location ..