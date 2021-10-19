$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'UniExtract2'
$category = 'Utilities'

VM-Uninstall $toolName $category
