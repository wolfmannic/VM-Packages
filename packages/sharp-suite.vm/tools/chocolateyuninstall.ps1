$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sharp-Suite'
$category = 'Exploitation'

VM-Uninstall $toolName $category
