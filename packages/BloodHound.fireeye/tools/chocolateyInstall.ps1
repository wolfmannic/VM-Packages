$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

$zipUrl = "https://github.com/BloodHoundAD/BloodHound/releases/download/3.0.2/BloodHound-win32-ia32.zip"
$zipSha256 = "F80352D7F6C1EAAC75EA3D252605A5B5E193683FBF743B40694A2D65E4A80537"

FE-Install-From-Zip $toolName $category $zipUrl $zipSha256 -zipFolder "BloodHound-win32-ia32"

