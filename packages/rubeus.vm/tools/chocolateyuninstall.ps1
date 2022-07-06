$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Exploitation'

VM-Uninstall $toolName $category
