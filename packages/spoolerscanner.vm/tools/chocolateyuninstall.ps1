$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SpoolerScanner'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
