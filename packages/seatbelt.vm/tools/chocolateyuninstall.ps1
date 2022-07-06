$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Seatbelt'
$category = 'Exploitation'

VM-Uninstall $toolName $category
