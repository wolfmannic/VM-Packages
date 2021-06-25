$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'x64dbg'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Debuggers'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  $snapshotDate = '2021-05-08_14-17'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = "https://sourceforge.net/projects/x64dbg/files/snapshots/snapshot_$snapshotDate.zip"
    checksum      = '441fa73605fcf0c2bbea9285bcd2b999fb02177a394c7e40464d74008d1793f9'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  FE-Assert-Path $toolDir

  $executablePath = Join-Path $toolDir "release\x32\x32dbg.exe"
  FE-Assert-Path $executablePath

  $shortcut = Join-Path $shortcutDir "x32dbg.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  FE-Assert-Path $shortcut

  Install-BinFile -Name 'x32dbg' -Path $executablePath

  $executablePath = Join-Path $toolDir "release\x64\x64dbg.exe"
  FE-Assert-Path $executablePath

  $shortcut = Join-Path $shortcutDir "x64dbg.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  FE-Assert-Path $shortcut

  Install-BinFile -Name 'x64dbg' -Path $executablePath
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}