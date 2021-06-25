$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Developer Tools'

  $programFiles = ${Env:ProgramFiles(x86)}
  if (-Not ($programFiles)) {
    $programFiles = ${Env:ProgramFiles}
  }

  $toolDir = Join-Path $programFiles 'Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build'
  FE-Assert-Path $target

  $shortcut = Join-Path $shortcutDir 'Microsoft Visual C++ Build Tools.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
  FE-Assert-Path $shortcut
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}