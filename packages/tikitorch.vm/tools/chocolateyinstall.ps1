$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TikiTorch'
$category = 'Exploitation'

$zipUrl = 'https://github.com/rasta-mouse/TikiTorch/archive/93a4512e25d6f9a5b3e3832cf79be22d058d9851.zip'
$zipSha256 = '67c1d425848e975b9dbd894c6482e24fcc545ca74243def154d403e9d6acfbaf'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
