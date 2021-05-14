$ErrorActionPreference = 'Stop'
$path = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
$shortcut = Join-Path $path 'cmder.lnk'
Remove-Item $shortcut -Force -ea 0 | Out-Null