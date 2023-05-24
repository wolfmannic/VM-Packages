$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


try {
    $toolName = 'de4dot'
    $category = 'dotNet'

    $zipUrl = 'https://github.com/ViRb3/de4dot-cex/releases/download/v4.0.0/de4dot-cex.zip'
    $zipSha256 = 'C726CBD18B894CA63B7F6A565C6C86EF512B96E68119C6502CDF64A51F6A1C78'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName-cex"
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolDir

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "$toolName-cex.lnk"
    $executablePath64 = Join-Path $toolDir "$toolName-x64.exe" -Resolve
    $shortcut64 = Join-Path $shortcutDir "$toolName-cex-x64.lnk"

    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    Install-ChocolateyShortcut -shortcutFilePath $shortcut64 -targetPath $executablePath64

    VM-Assert-Path $shortcut
    VM-Assert-Path $shortcut64

    Install-BinFile -Name $toolName -Path $executablePath
    Install-BinFile -Name "$toolName-x64" -Path $executablePath64
    return $executablePath
} catch {
    VM-Write-Log-Exception $_
}