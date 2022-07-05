$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'vulcan'
$category = 'Exploitation'

$zipUrl = 'https://github.com/praetorian-inc/vulcan/archive/a738c279c59425256d8ab512a55834a344e95f0e.zip'
$zipSha256 = 'abc24e8cc8b7662c7c53dc1611e6021053eb680ed2c4f679cf3ea12200f29eaa'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
