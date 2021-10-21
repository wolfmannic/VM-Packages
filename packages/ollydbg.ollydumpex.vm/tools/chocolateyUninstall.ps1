$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg'
VM-Assert-Path $toolDir

$pluginPath = Join-Path $toolDir 'OllyDumpEx_Od11.dll'
VM-Assert-Path $pluginPath

Remove-Item $pluginPath -Force -ea 0
