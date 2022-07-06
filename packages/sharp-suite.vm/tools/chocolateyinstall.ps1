$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sharp-Suite'
$category = 'Exploitation'

$zipUrl = 'https://github.com/FuzzySecurity/Sharp-Suite/archive/9c2f31f7ff706cb2daf0c50f4026711f45d51595.zip'
$zipSha256 = '4536c07a773d77e589500bcebfe0c5b152bbfddd9d46169c967158018159c026'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
