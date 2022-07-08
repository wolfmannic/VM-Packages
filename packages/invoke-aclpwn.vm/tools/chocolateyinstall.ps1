$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-ACLPwn'
$category = 'Information Gathering'

$ps1Url = 'https://github.com/fox-it/Invoke-ACLPwn/raw/a8455f18ed0bad09c6ccba4f0475a2520e97cc26/Invoke-ACLPwn.ps1'
$ps1Sha256 = '3a51bea5c0cae41d442bcf4a3c7dc50f6405bfb68bac7baac9f8525bdc46795f'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256
