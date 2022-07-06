$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SafetyKatz'
$category = 'Exploitation'

VM-Uninstall $toolName $category
