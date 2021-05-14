$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking
$path = Join-Path ${Env:TOOL_LIST_DIR} 'Developer Tools'

$programFiles = ${Env:ProgramFiles(x86)}
if (-Not ($programFiles)) {
  $programFiles = ${Env:ProgramFiles}
}

$target = Join-Path $programFiles 'Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build'
FE-Assert-Path $target

$shortcut = Join-Path $path 'Microsoft Visual C++ Build Tools.lnk'
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target