$ErrorActionPreference = 'Continue'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'hashmyfiles'
$category = 'Utilities'

FE-Uninstall $toolName $category

if (-Not (Test-Path -Path HKCR:)) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
Remove-Item -LiteralPath 'HKCR:\*\shell\HashMyFiles' -Recurse -Force | Out-Null
Remove-Item -LiteralPath 'HKCR:\Directory\shell\HashMyFiles' -Recurse -Force | Out-Null
