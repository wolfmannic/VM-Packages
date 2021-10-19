$ErrorActionPreference = 'Continue'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg2'
VM-Assert-Path $toolDir

$pluginPath = Join-Path $toolDir 'OllyDumpEx_Od20.dll'
VM-Assert-Path $pluginPath

Remove-Item $pluginPath -Force -ea 0
