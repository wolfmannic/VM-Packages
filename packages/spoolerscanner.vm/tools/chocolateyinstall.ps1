$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SpoolerScanner'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/vletoux/SpoolerScanner/archive/ee00f0ed5af0382a65d3a50651959433118f3178.zip'
$zipSha256 = 'd3d8192e931bf14b51325aa8f7884d58ea30f2c5c98515dff0b888ee198e7f60'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
