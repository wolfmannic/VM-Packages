$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking
$path = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'

$toolsDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cmder'
FE-Assert-Path $toolsDir

#### Change default ls alias to deconflict with unxUtils package ####
# https://github.com/cmderdev/cmder/issues/743
$cmderaliases = Join-Path $toolsDir 'config\user_aliases.cmd'
$content = @"
;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d `$1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
"@
Remove-Item $cmderaliases -ea 0
New-Item -ItemType File -Path $cmderaliases -Force | Out-Null
Set-Content -Path $cmderaliases -Value $content

$target_file = Join-Path $toolsDir 'cmder.exe'
FE-Assert-Path $target_file

$shortcut = Join-Path $path 'cmder.lnk'
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file