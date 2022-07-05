$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'vulcan'
$category = 'Exploitation'

VM-Uninstall $toolName $category
