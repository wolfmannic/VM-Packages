$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/Rubeus/archive/41c95e7385ec6e2aa46fcb354ab3cc94e8d24166.zip'
$zipSha256 = '17b5e400ec831c779a19f7f7d3853e47544261966bc15e63094f7d0179b65822'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
