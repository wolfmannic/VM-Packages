$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  $toolName = 'capa'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Remove files from previous zips for upgrade
  FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  # Download and unzip
  $url = "https://github.com/fireeye/capa/releases/download/v1.6.3/capa-v1.6.3-windows.zip"
  $checksum = "00e8d32941b3a1a58a164efc38826099fd70856156762647c4bbd9e946e41606"
  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  $executablePath = Join-Path $toolDir "$toolName.exe"
  FE-Assert-Path (Join-Path $toolDir "$toolName.exe")

  $executableIcon = $executablePath
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
  $executableArgs = "/K `"cd ${executableDir} && $toolName --help`""

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executableIcon
  FE-Assert-Path $shortcut
  Install-BinFile -Name $toolName -Path $executablePath
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}
