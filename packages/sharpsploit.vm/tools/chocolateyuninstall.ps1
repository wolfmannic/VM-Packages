$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpSploit'
$category = 'Exploitation'

VM-Uninstall $toolName $category
