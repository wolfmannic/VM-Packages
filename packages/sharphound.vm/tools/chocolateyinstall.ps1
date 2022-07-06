$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/archive/a89a4d33ee61c30915f8c8b6601af22093b3257a.zip'
$zipSha256 = 'af97ac4c768ff8022ff10a47e5ea83f29ac0d31346f27b93222bb0cbdf009ed6'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256


# $fullname = "SharpHound.exe"
# $url      = "https://github.com/BloodHoundAD/BloodHound/raw/0927441f67161cc6dc08a53c63ceb8e333f55874/Collectors/SharpHound.exe"
# $checksum = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

# $toolsDir = Join-Path "${Env:RAW_TOOLS_DIR}" $name
# if (-Not (Test-Path $toolsDir)) {
#   New-Item -Path $toolsDir -ItemType Directory -Force | Out-Null
# }

# $packageArgs = @{
#   packageName   = ${Env:ChocolateyPackageName}
#   FileFullPath  = Join-Path $toolsDir $fullname
#   url           = $url
#   checksum      = $checksum
#   checksumType  = 'sha256'
# }
# Get-ChocolateyWebFile @packageArgs

# $target_file = Join-Path $toolsDir "$name.exe"
# $target_cmd = Join-Path ${Env:WinDir} "system32\cmd.exe"
# $target_args = '/K "'+ "$target_file" +  ' -h"'
# $target_dir = $toolsDir
# $target_icon = $target_cmd
# $shortcut = Join-Path $path "$name.exe.lnk"
# Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_cmd -Arguments $target_args -WorkingDirectory $target_dir -IconLocation $target_icon
# Install-BinFile -Name "$name" -Path $target_file
