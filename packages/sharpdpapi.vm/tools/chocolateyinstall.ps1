$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDPAPI'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/SharpDPAPI/archive/b04655375c43dd67d716487baea53841405b3e98.zip'
$zipSha256 = '0a5cc926716b32eacad5764064064eedc633c5b7065ca13edfd2399cc51e7088'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
