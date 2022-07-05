$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AD ACL Scanner'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/canix1/ADACLScanner/archive/fb9759d191f71f2f257a97392edf361b75fc81bd.zip'
$zipSha256 = 'd77441b57160d538136af7608b9d8a8bbb5480915adc792fc05fc5dcd3043f0f'
$powershellCommand = '.\ADACLScan.ps1'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl -zipSha256 $zipSha256 -powershellCommand $powershellCommand