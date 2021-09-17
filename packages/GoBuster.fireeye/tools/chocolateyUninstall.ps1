$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

FE-Uninstall $toolName $category
