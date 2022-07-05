$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WMIOps'
$category = 'Command & Control'

VM-Uninstall $toolName $category
