# Steeltoe Continuous Integration

## Workflow Overview

Pushing changes to any Steeltoe repository on GitHub will trigger CI builds on both AppVeyor (Windows) and Travis CI (Linux and OSX). All NuGet packages are built in AppVeyor. Travis CI is used for cross-platform compatibility testing only.

## Work out of (or PR into) dev branch, packages deploy to myget/dev

Successful AppVeyor builds from the dev branch publish pre-release NuGet packages to the [Steeltoe Dev feed](https://www.myget.org/F/steeltoedev/api/v3/index.json) with a suffix of -dev-{build number}

## Stable code merged to master branch, packages deploy to myget/master

Once deemed stable, code is merged into the master branch. Successful AppVeyor builds from the master branch will publish pre-release NuGet packages to the [Steeltoe Master feed](https://www.myget.org/F/steeltoedev/api/v3/index.json) with a suffix of -master-{build number}

## Complete Steeltoe Releases - Publish to myget/staging then to nuget.org

When its time for a full release of Steeltoe, the [Steeltoe Universe PowerShell script](/scripts/steeltoe_universe.ps1) will be run on AppVeyor. The script will clone all repositories from GitHub into a temporary local workspace, update all Steeltoe versions in .props files to the version passed in as a parameter, build packages, (optionally) run unit tests, and publish to the [Steeltoe Staging feed](https://www.myget.org/F/steeltoestaging/api/v3/index.json).
Once the team is confident in the release, AppVeyor is used to push all packages to nuget.org via Environment deployments (click Deploy from the AppVeyor build)

Universe Script Options:

- `-BuildDebug` - using this switch causes the script to pull the default branch instead of master
- `$env:SteeltoeRepositoryList` - a space separated list of repositories; cloned and built in order specified. The default/complete list is maintained inside the Universe script
- `$env:RunUnitTests`: false (default)

## Patch releases

When patching is required: Create a branch named update{MajorMinor}x (eg: update20x for patches on the 2.0 release) if it does not already exist. Note: numbering of the branch does not affect build/deploy processes, the scripts only look for a starting value of ‘update’ in the branch name. Package versioning is controlled in appveyor.yml. Successful AppVeyor builds from update branches publish nuget packages to the Steeltoe Staging feed on myget.org with with no pre-release suffix unless the branch name includes one. For example: a branch named “update20x-rc1” will produce pre-release packages with the suffix -rc1, while “update20x” will produce packages with no suffix.
