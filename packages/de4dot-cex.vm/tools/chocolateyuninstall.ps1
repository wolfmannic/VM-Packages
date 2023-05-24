$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'de4dot-cex'
$toolName64 = 'de4dot-cex-x64'
$category = 'dotNet'

VM-Uninstall $toolName $category
VM-Uninstall $toolName64 $category
