$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'die'
$category = 'Utilities'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName "file"