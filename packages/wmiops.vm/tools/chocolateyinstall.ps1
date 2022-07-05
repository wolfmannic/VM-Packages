$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WMIOps'
$category = 'Command & Control'

$zipUrl = 'https://github.com/FortyNorthSecurity/WMIOps/archive/1d03946f40a2117efaed19eb5a52e36222abaf58.zip'
$zipSha256 = '83d905eb40959c777545b5191735c0e4ac8777450e1f382c73d2a1c74c395171'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
