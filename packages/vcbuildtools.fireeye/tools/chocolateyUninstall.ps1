$ErrorActionPreference = 'Stop'
$path = Join-Path ${Env:TOOL_LIST_DIR} 'Developer Tools'
$shortcut = Join-Path $path 'Microsoft Visual C++ Build Tools.lnk'
Remove-Item $shortcut -Force -ea 0 | Out-Null