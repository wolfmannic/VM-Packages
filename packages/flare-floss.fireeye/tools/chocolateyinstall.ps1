$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  $toolName = "FLOSS"
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'

  # Remove files from previous zips for upgrade
  FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Download and unzip
  $url = "https://github.com/fireeye/flare-floss/releases/download/v1.7.0/floss-v1.7.0-windows.zip"
  $checksum = "9b433a949b210bb8a856de2546cb075c349e0c2582ee9bf6b5fe51d9f95e7690"
  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  $executablePath = Join-Path $toolDir "$toolName.exe"
  FE-Assert-Path $executablePath

  # Create shortcut file
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
  $executableArgs = "/K `"cd ${executableDir} && $toolName --help`""
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath
  FE-Assert-Path $shortcut  
Install-BinFile -Path $executablePath -Name $toolName
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}
