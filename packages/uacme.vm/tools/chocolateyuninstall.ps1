$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'UACME'
$category = 'Exploitation'

VM-Uninstall $toolName $category
