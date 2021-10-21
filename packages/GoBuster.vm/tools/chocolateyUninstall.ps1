$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
