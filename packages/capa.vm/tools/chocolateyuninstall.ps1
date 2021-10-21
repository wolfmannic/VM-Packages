$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

VM-Uninstall $toolName $category
