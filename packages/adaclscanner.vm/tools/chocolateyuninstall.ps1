$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AD ACL Scanner'
$category = 'Information Gathering'

VM-Uninstall $toolName $category