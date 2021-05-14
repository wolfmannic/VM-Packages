$ErrorActionPreference = 'Continue'

$packageName = "FLOSS"
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0 | Out-Null

Uninstall-BinFile -Name $toolName