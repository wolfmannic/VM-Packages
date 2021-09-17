$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

FE-Uninstall $toolName $category

