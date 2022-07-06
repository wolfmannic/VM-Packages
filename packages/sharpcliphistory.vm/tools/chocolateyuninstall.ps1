$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpClipHistory'
$category = 'Exploitation'

VM-Uninstall $toolName $category
