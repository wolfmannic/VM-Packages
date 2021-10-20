# Run locally to test the packages, similar to .github/workflows/ci.yml
$packages_dir = 'packages' # Packages directory (e.g. the packages folder in the current directory)
$validExitCodes = @(0, 1605, 1614, 1641, 3010)

if (-Not (Test-Path $packages_dir)) { Exit 1 }

$built_pkgs_dir = New-Item -Force -ItemType Directory built_pkgs
$package_dirs = Get-ChildItem -Path $packages_dir | % { $_.FullName }

foreach ($package_dir in $package_dirs) {
    Set-Location $package_dir
    choco pack -out $built_pkgs_dir
    if ($LASTEXITCODE -ne 0) { Exit 1 } # Abort with the first failing build
}

Set-Location $built_pkgs_dir
$built_pkgs = Get-ChildItem $built_pkgs_dir
foreach ($package in $built_pkgs) {
  choco install $package -y
  if ($validExitCodes -notcontains $LASTEXITCODE) { Exit 1 } # Abort with the first failing install
}

echo "FLARE-VM WORKS!!!!"
