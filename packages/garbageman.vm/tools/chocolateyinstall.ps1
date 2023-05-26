$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GarbageMan'
$category = 'dotNet'

$zipUrl = 'https://github.com/WithSecureLabs/GarbageMan/releases/download/v0.2.4/GarbageMan-0.2.4.zip'
$zipSha256 = '84007e73a21c491e9517ff70955fc8ff02b0a4a0d562d3e21521b6169b21004e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
