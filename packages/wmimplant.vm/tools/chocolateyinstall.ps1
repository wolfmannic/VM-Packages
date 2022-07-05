$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WMImplant'
$category = 'Command & Control'

$zipUrl = 'https://github.com/FortyNorthSecurity/WMImplant/archive/0ed3c3cba9c5e96d0947c3e73288d450ac8d8702.zip'
$zipSha256 = '3aa92b685be30671e8dab61e85cd15ca56bb28f1b217c98c1930780a5bf05a82'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
