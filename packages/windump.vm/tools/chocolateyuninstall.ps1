$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinDump'
$category = 'Networking Tools'

VM-Uninstall $toolName $category
