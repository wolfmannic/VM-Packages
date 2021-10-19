$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

VM-Uninstall $toolName $category

