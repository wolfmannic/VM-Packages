$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

$toolName = 'hashmyfiles'
$category = 'Utilities'

$zipUrl = "https://www.nirsoft.net/utils/hashmyfiles.zip"
$zipSha256="89db49ec6a3e50f1d76da97ac1289272d1b09b9a330d36f65fdbe1f010f1ae8b"
$zipUrl_64 = "https://www.nirsoft.net/utils/hashmyfiles-x64.zip"
$zipSha256_64="be2dc5b9613b72ca44e60b7a1b5332593a868079638ded37cc3ad120e7182b0b"


try {
  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 $zipUrl_64 $zipSha256_64)[-1]

  # Chocolatey apends \"1\" to the command, but the \ breaks the command in our case. We need to add it in the correct format.
  Install-ChocolateyExplorerMenuItem -MenuKey "HashMyFiles" -MenuLabel "HashMyFiles" -Command "$executablePath /file `"%1`"" -Type "file"
  Install-ChocolateyExplorerMenuItem -MenuKey "HashMyFiles" -MenuLabel "HashMyFiles" -Command "$executablePath /file `"%1`"" -Type "directory"
} catch {
  $msg = $_.Exception.Message
  $line = $_.InvocationInfo.ScriptLineNumber
  VM-Write-Log "ERROR" "[Err:$line] $msg"
  throw
}
