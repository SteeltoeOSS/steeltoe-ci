Set-Location test

[int]$errors = 0

# run unit tests in each project in the test folder
Get-ChildItem -Directory -Filter "*.Test" | ForEach-Object {
	Set-Location $_.Name
	dotnet restore
	# use dotnet test until dotnet xunit works on netcoreapp2.1
	# dotnet xunit -verbose
	dotnet test -v d
	$errors = $errors + $lastexitcode
	Set-Location ..
}

Set-Location ..

If ($errors -gt 0)
{
    Throw "$errors test(s) failed" 
}