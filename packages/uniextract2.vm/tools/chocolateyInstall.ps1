$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

try {
  $toolName = 'UniExtract'
  $category = 'Utilities'

  $zipUrl = "https://github.com/Bioruebe/UniExtract2/releases/download/v2.0.0-rc.3/UniExtractRC3.zip"
  $zipSha256 = "03170680b80f2afdf824f4d700c11b8e2dac805a4d9bd3d24f53e43bd7131c3a"

  VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -zipFolder "UniExtract"

  # Make sure all *.exe are not shimmed
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  VM-Assert-Path $toolDir
  Get-ChildItem -Include '*.exe' -Path $toolDir -Recurse | %{ New-Item -Path "$_.ignore" -Type File | Out-Null }
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  VM-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}