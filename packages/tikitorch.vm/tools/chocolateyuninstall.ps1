$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TikiTorch'
$category = 'Exploitation'

VM-Uninstall $toolName $category
