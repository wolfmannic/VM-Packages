$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'UniExtract2'
$category = 'Utilities'

FE-Uninstall $toolName $category
