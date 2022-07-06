$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Seatbelt'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/Seatbelt/archive/6fc7ed1877c4055bdf27f52ef1e3880d17eaad46.zip'
$zipSha256 = '9244cba60e176a248c8d1f211c686bd6e527a4690d569e3d8d174bbc6628edf7'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
