$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'UniExtract'
$category = 'Utilities'

VM-Uninstall $toolName $category
