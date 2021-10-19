$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking
VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}
