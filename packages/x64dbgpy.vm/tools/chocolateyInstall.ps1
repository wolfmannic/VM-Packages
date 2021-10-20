$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release'
  VM-Assert-Path $toolDir

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/x64dbg/x64dbgpy/releases/download/b275005/x64dbgpy_b275005.zip'
    checksum      = '62ffbbcf0218c3b833bcb36c2a10671c4501007759a84164b63f09e9f2ce9bfc'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  # Check for a few expected files to ensure installation succeeded
  VM-Assert-Path (Join-Path $toolDir 'x64dbgpy.h')
  VM-Assert-Path (Join-Path $toolDir 'x64dbgpy_x64.lib')
  VM-Assert-Path (Join-Path $toolDir 'x64dbgpy_x86.lib')
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  VM-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}