$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'OllyDbg2'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Debuggers'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'http://www.ollydbg.de/odbg201.zip'
    checksum      = '29244e551be31f347db00503c512058086f55b43c93c1ae93729b15ce6e087a5'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  FE-Assert-Path $toolDir

  $executablePath = Join-Path $toolDir "ollydbg.exe"
  FE-Assert-Path $executablePath

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  FE-Assert-Path $shortcut

  Install-BinFile -Name 'ollydbg2' -Path $executablePath
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}