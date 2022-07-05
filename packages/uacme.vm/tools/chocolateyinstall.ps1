$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'UACME'
$category = 'Exploitation'

$zipUrl = 'https://github.com/hfiref0x/UACME/archive/af0b0d643809802156c71e31546ca4fc3a2e7f1b.zip'
$zipSha256 = '1da2b1c332ae9c5f197d80df7ded3f32d04cfe21fe0a47a41be2604cc6f53da1'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
