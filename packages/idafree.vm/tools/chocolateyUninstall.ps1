$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'idafree'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Disassemblers'

# Remove shortcut file
$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Attempt to find and execute the uninstaller
[array]$key = Get-UninstallRegistryKey -SoftwareName 'IDA Freeware*?7.6'
if ($key.Count -eq 1) {
  $packageArgs = @{
    packageName = ${Env:ChocolateyPackageName}
    fileType    = 'exe'
    silentArgs  = '--mode unattended'
    file        = $key[0].UninstallString
  }
  Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
  VM-Write-Log "WARN" "${Env:ChocolateyPackageName} has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  VM-Write-Log "WARN" "$($key.Count) matches found!"
  VM-Write-Log "WARN" "To prevent accidental data loss, no targeted uninstallation will occur."
  VM-Write-Log "WARN" "The following installation values were found:"
  $key | % {VM-Write-Log "WARN" " - $($_.DisplayName)"}
  VM-Write-Log "WARN" "Now allowing Chocolatey's auto uninstaller a chance to run."
}