$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg'
FE-Assert-Path $toolDir

$pluginPath = Join-Path $toolDir 'OllyDumpEx_Od11.dll'
FE-Assert-Path $pluginPath

Remove-Item $pluginPath -Force -ea 0
