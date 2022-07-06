$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpSploit'
$category = 'Exploitation'

$zipUrl = 'https://github.com/cobbr/SharpSploit/archive/c16931ddb8cd2335e0bd26feb9aaa35f449d48db.zip'
$zipSha256 = '3614ed0a9fad91293d2b060843e51b91519dd722e27ba3f96eb8e6a05523813c'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
