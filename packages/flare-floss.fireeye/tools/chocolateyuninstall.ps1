$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

FE-Uninstall $toolName $category
