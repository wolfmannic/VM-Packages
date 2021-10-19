$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

try {
  $toolName = 'FakeNet-NG'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Net'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  # Download and unzip
  $url = "https://github.com.vm/flare-fakenet-ng/releases/download/v1.4.11/fakenet1.4.11.zip"
  $checksum = "62af5cce80dbbf5cdf961ec9515549334a2112056d4168fced75c892c24baa95"
  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  $executablePath = Join-Path $toolDir "fakenet1.4.11\fakenet.exe"
  VM-Assert-Path $executablePath

  # Create shortcut file
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir = Join-Path $toolDir "fakenet1.4.11"
  $executableArgs = "/K `"cd ${executableDir} && fakenet.exe`""
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Install shim the hard way until this is fixed: https://github.com/chocolatey/choco/issues/1273
  $launcher = Join-Path $env:ChocolateyInstall "bin\fakenet.exe"
  $sg = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'
  VM-Assert-Path $sg
  & $sg -o $launcher -p $ExecutableCmd -c "/K 'cd ${executableDir} && fakenet.exe'" | Out-Null
  VM-Assert-Path $launcher

  # Create shortcut to actual tools dir
  $logDir  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $logDir -targetPath $executableDir
  VM-Assert-Path $logDir
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  VM-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}
