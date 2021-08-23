$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/fireeye/capa/releases/download/v1.6.3/capa-v1.6.3-windows.zip"
$zipSha256 = "00e8d32941b3a1a58a164efc38826099fd70856156762647c4bbd9e946e41606"

FE-Install-From-Zip $toolName $category $zipUrl $zipSha256

