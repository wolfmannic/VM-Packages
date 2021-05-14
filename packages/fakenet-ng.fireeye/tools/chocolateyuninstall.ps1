$ErrorActionPreference = 'Continue'

$toolName = 'FakeNet-NG'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Net'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

# Remove shortcut file
$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0

# Remove tool files
Remove-Item $toolDir -Recurse -Force -ea 0

# Remove shim
$shim = Join-Path $env:ChocolateyInstall "bin\fakenet.exe"
Remove-Item $shim -Force -ea 0

# Remove fakenet_logs LNK file
$logDir  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
Remove-Item $logDir -Force -ea 0