# Output dotnet info
dotnet --info

$env:CI_BUILD = $env:APPVEYOR
$env:STEELTOE_VERSION = $env:APPVEYOR_BUILD_VERSION.Replace("-$env:APPVEYOR_REPO_BRANCH-$env:APPVEYOR_BUILD_NUMBER", "")
Write-Host "NuGet package version to build: $env:STEELTOE_VERSION"

$env:BUILD_TYPE = "Release"

Write-Host "Branch to build is $env:APPVEYOR_REPO_BRANCH"
# use STEELTOE_VERSION_SUFFIX to set the pre-release version on packages
If ($env:APPVEYOR_REPO_BRANCH.StartsWith("update")) {
	# if this build is from an update branch, only use pre-release suffixes from the branch name (if found)
	$env:STEELTOE_VERSION_SUFFIX = $env:APPVEYOR_REPO_BRANCH.Split("-")[1]
}
Else {
	$env:STEELTOE_VERSION_SUFFIX = "$env:APPVEYOR_REPO_BRANCH-" + $env:APPVEYOR_BUILD_NUMBER.ToString().PadLeft(5, "0")
}
# use this variable to refer to dependencies within the current solution that are built during CI builds
If ($env:STEELTOE_VERSION_SUFFIX){
	$env:STEELTOE_DASH_VERSION_SUFFIX = "-$env:STEELTOE_VERSION_SUFFIX"
}
Else {
	$env:STEELTOE_DASH_VERSION_SUFFIX = ""
}

Write-Host "Package version suffix to use: $env:STEELTOE_VERSION_SUFFIX"

# add MyGet server as required, copy versions.props to solution root for use later
If ($env:APPVEYOR_REPO_BRANCH -eq "master") {
	Write-Host "Use dependencies from nuget.org and https://www.myget.org/F/steeltoemaster/api/v3/index.json"
	nuget sources add -Name Steeltoe -Source https://www.myget.org/F/steeltoemaster/api/v3/index.json
	$env:PropsVersion = "-master"
}
ElseIf ($env:APPVEYOR_REPO_BRANCH -eq "dev") {
	# this feed is already in the nuget.config at the root of each repo...
	#Write-Host "Use dependencies from nuget.org and https://www.myget.org/F/steeltoedev/api/v3/index.json"
	#nuget sources add -Name Steeltoe -Source https://www.myget.org/F/steeltoedev/api/v3/index.json
	$env:PropsVersion = "-dev"
	$env:BUILD_TYPE = "Debug"
}
ElseIf ($env:APPVEYOR_REPO_BRANCH.StartsWith("update")) {
	Write-Host "Use dependencies from nuget.org and https://www.myget.org/F/steeltoestaging/api/v3/index.json"
	nuget sources add -Name Steeltoe -Source https://www.myget.org/F/steeltoestaging/api/v3/index.json
}
If (Test-Path config/versions.props)
{
	Write-Host "Using .\config\versions$env:PropsVersion.props"	
	Copy-Item .\config\versions$env:PropsVersion.props -Destination .\versions.props	
}

# setup a local folder NuGet feed for use during the build
mkdir $env:APPVEYOR_BUILD_FOLDER\localfeed -Force
nuget sources add -Name localfeed -Source $env:APPVEYOR_BUILD_FOLDER\localfeed