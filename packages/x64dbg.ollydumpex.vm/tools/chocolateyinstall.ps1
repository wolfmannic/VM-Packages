$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolSrcDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolSrcDir
    url           = 'https://low-priority.appspot.com/ollydumpex/OllyDumpEx_v1.80.zip'
    checksum      = 'f4956adf59722242503b09a4503d269565990efa0c41d7062e2a8e95f61bff5c'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  # Should unzip to the directory below
  $toolSrcDir = Join-Path $toolSrcDir 'OllyDumpEx_v1.80'
  VM-Assert-Path $toolSrcDir

  $pluginSrcPath = Join-Path $toolSrcDir 'OllyDumpEx_X64Dbg.dp32'
  VM-Assert-Path $pluginSrcPath

  $toolDstDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x32'
  VM-Assert-Path $toolDstDir

  $toolDstDir = Join-Path $toolDstDir 'plugins'
  if ( -Not (Test-Path $toolDstDir -PathType Container)) {
    New-Item -ItemType directory $toolDstDir -Force -ea 0
  }
  VM-Assert-Path $toolDstDir

  # Move correct plugin into the tool directory
  $pluginDstPath = Join-Path $toolDstDir $pluginFile
  Move-Item -Path $pluginSrcPath -Destination $pluginDstPath -Force -ea 0
  VM-Assert-Path $pluginDstPath

  $pluginSrcPath = Join-Path $toolSrcDir 'OllyDumpEx_X64Dbg.dp64'
  VM-Assert-Path $pluginSrcPath

  $toolDstDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x64'
  VM-Assert-Path $toolDstDir

  $toolDstDir = Join-Path $toolDstDir 'plugins'
  if ( -Not (Test-Path $toolDstDir -PathType Container)) {
    New-Item -ItemType directory $toolDstDir -Force -ea 0
  }
  VM-Assert-Path $toolDstDir

  # Move correct plugin into the tool directory
  $pluginDstPath = Join-Path $toolDstDir $pluginFile
  Move-Item -Path $pluginSrcPath -Destination $pluginDstPath -Force -ea 0
  VM-Assert-Path $pluginDstPath
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  VM-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}