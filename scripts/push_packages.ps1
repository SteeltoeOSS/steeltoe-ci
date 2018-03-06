Param(
    [Parameter(Mandatory=$true)]
    [string]$PackageSource,
    [Parameter(Mandatory=$true)]
    [string]$VersionFilter,
    [Parameter(Mandatory=$true)]
    [string]$PackageDestination
 )
 $UploadTime = New-Object -TypeName System.Diagnostics.Stopwatch
 $UploadTime.Start()

 If (-Not $env:NuGetApiKey) {
    Write-Error "Sorry, you can't push nuget packages without setting env:NuGetApiKey" 
    return -1
 }

 Write-Host "Locating $PackageSource"
 Set-Location $PackageSource
 $counter = 1
 $PackageList = Get-ChildItem -Filter $VersionFilter
 ForEach ($_ in $PackageList) {
    Write-Host "Now pushing package $counter of" $PackageList.Count
    nuget push $_ $env:NuGetApiKey -Source $PackageDestination 
    $counter++
 }
 Set-Location ..

 $UploadTime.Stop()
 Write-Host "Upload process time:" $UploadTime.Elapsed.ToString()