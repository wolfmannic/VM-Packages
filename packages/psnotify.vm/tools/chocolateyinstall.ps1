$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'psnotify'
    $category = 'dotNet'

    $zipUrl = 'https://github.com/WithSecureLabs/GarbageMan/releases/download/v0.2.4/psnotify.zip'
    $zipSha256 = '255633da6e61bf30a67bce995ef72b7f9d8c85c75c8c5ee0aedb48709f7e6454'

    $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true)
    $innerPath = Join-Path $executablePath[0] "psnotify" -Resolve
    Move-Item -Path $innerPath -Destination "C:\" -Force -ea 0
    Remove-Item $executablePath -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}
