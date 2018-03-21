# use this script if you'd like to run build/test/install scripts on your workstation
# be sure to run it from within the repo folder
$env:APPVEYOR=$true
If ($env:APPVEYOR_BUILD_NUMBER){
    $env:APPVEYOR_BUILD_NUMBER = [int]$env:APPVEYOR_BUILD_NUMBER + 1
}
Else {
    $env:APPVEYOR_BUILD_NUMBER = 1
}
$env:APPVEYOR_REPO_BRANCH = git rev-parse --abbrev-ref HEAD

Write-Host "This script does not actually read your appveyor.yml file. Your input will be used to set APPVEYOR_BUILD_VERSION..."
$env:STEELTOE_VERSION = Read-Host -Prompt 'What base version would you like to use for packages? Do not include a pre-release suffix'
$env:APPVEYOR_BUILD_VERSION = "$env:STEELTOE_VERSION-$env:APPVEYOR_REPO_BRANCH-$env:APPVEYOR_BUILD_NUMBER"
$env:APPVEYOR_BUILD_FOLDER = $pwd

Write-Host "AppVeyor Simulation setup complete to run build $env:APPVEYOR_BUILD_VERSION in $env:APPVEYOR_BUILD_FOLDER for branch $env:APPVEYOR_REPO_BRANCH"