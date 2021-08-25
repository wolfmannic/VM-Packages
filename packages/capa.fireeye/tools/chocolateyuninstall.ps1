$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

FE-Uninstall $toolName $category
