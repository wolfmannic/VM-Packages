$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

VM-Uninstall $toolName $category
