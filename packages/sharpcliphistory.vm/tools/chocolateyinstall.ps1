$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpClipHistory'
$category = 'Exploitation'

$zipUrl = 'https://github.com/FSecureLABS/SharpClipHistory/archive/881cfd07ac10d7af3180375bac5fe4eb66e06a47.zip'
$zipSha256 = 'fcb230348255d14a0f777d251c5877448be478526cabe7e69512979a838558cb'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
