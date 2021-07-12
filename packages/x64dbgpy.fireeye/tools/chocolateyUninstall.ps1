$ErrorActionPreference = 'Stop'
Import-Module FireEyeVM.common -Force -DisableNameChecking
FE-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}