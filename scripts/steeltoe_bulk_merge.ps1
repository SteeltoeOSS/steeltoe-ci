#############################################################################################
# This is a script for merging commits from one branch to another in all Steeltoe Libraries #
#############################################################################################
Param(
    [string]$source = "master",
    [string]$destination = "dev"
 )

 #If (-Not $env:SteeltoeRepositoryList) {
    Write-Host "Steeltoe repository list not set in Environment, using complete list"
    $s = "SteeltoeOSS"
    $p = "pivotal-cf"
    $env:SteeltoeRepositoryList = "$s/Common $s/Configuration $p/spring-cloud-dotnet-configuration $s/logging $s/connectors " + 
                                        "$s/discovery $p/spring-cloud-dotnet-discovery $s/security $s/management $s/circuitbreaker"
#}
#Else {
#    Write-Host "Using repository list from environment: $env:SteeltoeRepositoryList"
#}

# for each project
ForEach ($_ in $env:SteeltoeRepositoryList.Split(' ')) {
    # if the repo hasn't been cloned yet (eg: doing the merge from a clean workspace)
    If (!(Test-Path -Path $_.Split("/")[1])) {
        $cloneString = "git clone -q $env:BranchFilter https://github.com/$_.git"
        Write-Host "Cloning repository with this command: " $cloneString
        Invoke-Expression $cloneString
    }
    Else {
        Write-Host "$_ found on disk, pulling latest"
    }

    Set-Location $_.Split("/")[1]
    # make sure the destination branch is checked out
    Invoke-Expression "git checkout $destination"
    # be current
    Invoke-Expression "git pull"
    # merge the changes
    Invoke-Expression "git merge $source"
    Set-Location ..
}