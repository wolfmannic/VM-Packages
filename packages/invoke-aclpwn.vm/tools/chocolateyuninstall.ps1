$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-ACLPwn'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
