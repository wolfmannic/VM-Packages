$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

try {
  FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release'
  FE-Assert-Path $toolDir

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://ci.appveyor.com/api/buildjobs/r8she167c5eu39f2/artifacts/release.zip'
    checksum      = '691c92f864c869b5e0aded9691b33e445bfae736a94fe266e788cb80379074db'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  # Check for a few expected files to ensure installation succeeded
  FE-Assert-Path (Join-Path $toolDir 'x64dbgpy.h')
  FE-Assert-Path (Join-Path $toolDir 'x64dbgpy_x64.lib')
  FE-Assert-Path (Join-Path $toolDir 'x64dbgpy_x86.lib')
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  FE-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}