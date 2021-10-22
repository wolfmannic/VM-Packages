$ErrorActionPreference = 'Continue'


# ################################################################################################ #
# \ \ ---------------------------------------- N O T E ---------------------------------------- / /
#
#     Below are general helper functions for any VM package to use
#
# ################################################################################################ #

function VM-ConvertTo-HashTable([object] $jsonTree) {
  $result = @{}
  foreach ($node in $jsonTree) {
    foreach ($property in $node.Keys) {
      if ($node[$property] -is [System.Collections.Generic.Dictionary[String, Object]] -or $node[$property] -is [Object[]]) {
        $result[$property] = VM-ConvertTo-HashTable $node[$property]
      } else {
        $result[$property] = $node[$property]
      }
    }
  }
  $result
}


function VM-ConvertFrom-Json([object] $item) {
<#
.SYNOPSIS
  Convert a JSON string into a hash table

.DESCRIPTION
  Convert a JSON string into a hash table, without any validation

.OUTPUTS
  [hashtable] or $null
#>
  Add-Type -Assembly system.web.extensions
  $ps_js = New-Object system.web.script.serialization.javascriptSerializer

  try {
    $result = $ps_js.DeserializeObject($item)
  } catch {
    $result = $null
  }

  # Cast dictionary to hashtable
  [hashtable] $result
}


function VM-ConvertTo-Json([object] $data) {
<#
.SYNOPSIS
  Convert a hashtable to a JSON string

.DESCRIPTION
  Convert a hashtable to a JSON string, without any validation

.OUTPUTS
  [string] or $null
#>
  Add-Type -Assembly system.web.extensions
  $ps_js = New-Object system.web.script.serialization.javascriptSerializer

  #The comma operator is the array construction operator in PowerShell
  try {
    $result = $ps_js.Serialize($data)
  } catch {
    $result = $null
  }

  $result
}


function VM-Import-JsonFile {
<#
.DESCRIPTION
  Load a hashtable from a JSON file

.OUTPUTS
  [hashtable] or $null
#>
  param([string] $path)
  try {
    $json = Get-Content $path
    $result = VM-ConvertFrom-Json $json
  } catch {
    $result = $null
  }

  $result
}


function VM-Install-OnePackage {
<#
.DESCRIPTION
  Install a package, specified by a hash table with the following properties:
  $pkg = @{
    name = "foo.python"
    args = "--source python"
    x64Only = $true
  }

.OUTPUTS
  $true OR $false
#>
  param([hashtable] $pkg)
  $name = $pkg.name
  $pkgargs = $pkg.args
  try {
    $is64Only = $pkg.x64Only
  } catch {
    $is64Only = $false
  }

  if ($is64Only) {
    if (Get-OSArchitectureWidth -Compare 64) {
      # pass
    } else {
      Write-Warning "[!] Not installing $name on x86 systems"
      return $true
    }
  }

  if ($pkgargs -eq $null) {
    $args = $globalCinstArgs
  } else {
    $args = $pkgargs,$globalCinstArgs -Join " "
  }

  if ($args -like "*-source*" -Or $args -like "*--package-parameters*" -Or $args -like "*--parameters*") {
    Write-Warning "[!] Installing using host choco.exe! Errors are ignored. Please check to confirm $name is installed properly"
    Write-Warning "[!] Executing: iex choco upgrade $name $args"
    $rc = iex "choco upgrade $name $args"
    Write-Host $rc
  } else {
    choco upgrade $name $args
  }

  if ($([System.Environment]::ExitCode) -ne 0 -And $([System.Environment]::ExitCode) -ne 3010) {
    Write-Host "ExitCode: $([System.Environment]::ExitCode)"
    return $false
  }
  return $true
}


function VM-Install-Packages {
<#
.DESCRIPTION
  Install a list of packages, following this JSON format:
  [
    {"name": "foo"},
    {"name": "bar", "x64Only": true},
    {"name": "foo.python", "args": "--source python"},
    {"name": "bar.fancy", "args": "--package-parameters \'/InstallDir:C\\bar.fancy\'"}
  ]
.OUTPUTS
  None, however it may write to stderr
#>
  param([hashtable] $packages)
  foreach ($pkg in $packages) {
    $rc = VM-Install-OnePackage $pkg
    $name = $pkg.name
    if ($rc) {
      # self throttle
      if (-Not ($name.Contains(".flare") -Or -Not ($name.Contains(".vm")))) {
        Start-Sleep -Seconds 4
      }
    } else {
      Write-Error "Failed to install $name"
    }
  }
}


function VM-Remove-PreviousZipPackage {
<#
.DESCRIPTION
  Remove files from previous zips for upgrade. They should be listed in a *.txt file.
  If no expression is provided, it will look for files matching: *.zip.txt and *.7z.txt
.PARAMETER packagePath
  Path to the chocolatey package (usually %PROGRAMDATA%\Chocolatey\lib\<package_name>)
.PARAMETER expression
  [OPTIONAL] A wildcard expression for a file type containing a list of files to delete.
#>
  param(
    [string] $packagePath,
    [string] $expression=$null
  )

  if ($expression) {
    $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath $expression)
  } else {
    $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath "*.zip.txt"), (Join-Path $packagePath "*.7z.txt")
  }

  foreach ($zipFileName in $previousZipFiles) {
    if ((Test-Path -Path $zipFileName)) {
      $zipContents = Get-Content $zipFileName -Force
      foreach ($fileInZip in $zipContents) {
        if ($fileInZip -ne $null -and $fileInZip.Trim() -ne '' -and (Test-Path "$fileInZip")) {
          Remove-Item -Path "$fileInZip" -ErrorAction SilentlyContinue -Recurse -Force
        }
      }
    }
  }
}


# Set Pinned Applications from https://gist.github.com/jhorsman/0e4655da25c3e1700cb2
function VM-Set-PinnedApplication {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][string]$Action,
    [Parameter(Mandatory=$true)][string]$FilePath
  )
  if(-not (test-path $FilePath)) {
    throw "FilePath does not exist."
  }

  function InvokeVerb {
    param([string]$FilePath,$verb)
    $verb = $verb.Replace("&","")
    $path= split-path $FilePath
    $shell=new-object -com "Shell.Application"
    $folder=$shell.Namespace($path)
    $item = $folder.Parsename((split-path $FilePath -leaf))
    $itemVerb = $item.Verbs() | ? {$_.Name.Replace("&","") -eq $verb}
    if($itemVerb -eq $null){
      throw "Verb $verb not found."
    } else {
      $itemVerb.DoIt()
    }
  }

  function GetVerb {
    param([int]$verbId)
    try {
      $t = [type]"CosmosKey.Util.MuiHelper"
    } catch {
      $def = [Text.StringBuilder]""
      [void]$def.AppendLine('[DllImport("user32.dll")]')
      [void]$def.AppendLine('public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);')
      [void]$def.AppendLine('[DllImport("kernel32.dll")]')
      [void]$def.AppendLine('public static extern IntPtr LoadLibrary(string s);')
      add-type -MemberDefinition $def.ToString() -name MuiHelper -namespace CosmosKey.Util
    }
    if($global:CosmosKey_Utils_MuiHelper_Shell32 -eq $null){
      $global:CosmosKey_Utils_MuiHelper_Shell32 = [CosmosKey.Util.MuiHelper]::LoadLibrary("shell32.dll")
    }
    $maxVerbLength=255
    $verbBuilder = new-object Text.StringBuilder "",$maxVerbLength
    [void][CosmosKey.Util.MuiHelper]::LoadString($CosmosKey_Utils_MuiHelper_Shell32,$verbId,$verbBuilder,$maxVerbLength)
    return $verbBuilder.ToString()
  }

  $verbs = @{
    "PintoStartMenu"=5381
    "UnpinfromStartMenu"=5382
    "PintoTaskbar"=5386
    "UnpinfromTaskbar"=5387
  }

  if ($verbs.$Action -eq $null) {
    Throw "Action $action not supported`nSupported actions are:`n`tPintoStartMenu`n`tUnpinfromStartMenu`n`tPintoTaskbar`n`tUnpinfromTaskbar"
  }
  InvokeVerb -FilePath $FilePath -Verb $(GetVerb -VerbId $verbs.$action)
}


function VM-Write-Log {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String] $level,

    [Parameter(Mandatory=$true, Position=1)]
    [string] $message
  )
  # Get log file
  $envVarName = "VM_COMMON_DIR"
  $commonDirPath = [Environment]::GetEnvironmentVariable($envVarName, 2)
  $logFile = Join-Path $commonDirPath "log.txt"

  # If log file doesn't exist, create it
  if (-Not (Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType file -Force | Out-Null
  }

  # Log message to file
  $stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
  try {
    $scriptName = Split-Path -Path $MyInvocation.ScriptName -Leaf
    if ((${Env:chocolateyPackageFolder}) -AND (Test-Path env:\"chocolateyPackageFolder")) {
      $choco_dir = Split-Path -Path ${Env:chocolateyPackageFolder} -Leaf
      $line = "$stamp [$choco_dir] $scriptName [+] $level : $message"
    } else {
      $line = "$stamp $scriptName [+] $level : $message"
    }
  } catch {
    $line = "$stamp [+] $level : $message"
  }
  Add-Content $logfile -Value $line

  # Log message to console
  if (($level -eq "ERROR") -Or ($level -eq "FATAL")) {
    Write-Host -ForegroundColor Red -BackgroundColor White "$line"
  } elseif ($level -eq "WARN") {
    Write-Host -ForegroundColor Yellow "$line"
  } else {
    Write-Host "$line"
  }
}

function VM-Assert-Path {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [String] $path
  )

  if (-Not (Test-Path $path)) {
    $err_msg = "Invalid path: $path"
    VM-Write-Log "ERROR" $err_msg
    throw $err_msg
  }
}

function VM-Get-DiskSize {
  $diskdrive = "${Env:SystemDrive}"
  $driveName = $diskdrive.substring(0, $diskdrive.length-1)
  $disk = Get-PSDrive "$driveName"
  $disksize = (($disk.used + $disk.free)/1GB)
  return $disksize
}

function VM-Get-FreeSpace {
  [double]$freeSpace = 0.0
  [string]$wql = "SELECT * FROM Win32_LogicalDisk WHERE MediaType=12"
  $drives = Get-WmiObject -query $wql
  if($null -ne $drives) {
      foreach($drive in $drives) {
          $freeSpace += ($drive.freeSpace)
      }
  }

  return ($freeSpace / 1GB)
}

function VM-Check-Reboot {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [String] $package
  )
  try {
    if (Test-PendingReboot){
      VM-Write-Log "ERROR" "[Err] Host must be rebooted before continuing install of $package.`n"
      Invoke-Reboot
      exit 1
    }
  } catch {
    continue
  }
}

function VM-New-Install-Log {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [String] $dir
  )
  VM-Assert-Path $dir
  $outputFile = Join-Path $dir "install_log.txt"
  if (-Not (Test-Path $outputFile)) {
    New-Item -Path $outputFile -Force | Out-Null
  }
  $(Get-Date -f o) | Out-File -FilePath $outputFile -Append
  return $outputFile
}

# This functions returns $executablePath and $toolDir (outputed by Install-ChocolateyZipPackage)
function VM-Install-From-Zip {
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory=$true, Position=0)]
    [string] $toolName,
    [Parameter(Mandatory=$true, Position=1)]
    [string] $category,
    [Parameter(Mandatory=$true, Position=2)]
    [string] $zipUrl,
    [Parameter(Mandatory=$true, Position=3)]
    [string] $zipSha256,
    [Parameter(Mandatory=$false, Position=4)]
    [string] $zipUrl_64,
    [Parameter(Mandatory=$false, Position=5)]
    [string] $zipSha256_64,
    [Parameter(Mandatory=$false)]
    [bool] $consoleApp=$false,
    [Parameter(Mandatory=$false)]
    [string] $zipFolder # subfolder in zip with the app files
  )
  try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    # Download and unzip
    $packageArgs = @{
      packageName   = ${Env:ChocolateyPackageName}
      unzipLocation = $toolDir
      url           = $zipUrl
      checksum      = $zipSha256
      url64bit      = $zipUrl_64
      checksum64    = $zipSha256_64
      checksumType  = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs

    if ($zipFolder) {
      $toolDir = Join-Path $toolDir $zipFolder
    }

    $executablePath = Join-Path $toolDir "$toolName.exe"
    VM-Assert-Path (Join-Path $toolDir "$toolName.exe")
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    if ($consoleApp) {
      $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
      $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
      $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath
    } else {
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    }

    VM-Assert-Path $shortcut

    Install-BinFile -Name $toolName -Path $executablePath

    return $executablePath
  } catch {
    VM-Write-Log-Exception $_
  }
}

function VM-Uninstall {
  Param
  (
    [Parameter(Mandatory=$true, Position=0)]
    [string] $toolName,
    [Parameter(Mandatory=$true, Position=1)]
    [string] $category
  )
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  # Remove tool files
  Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

  # Remove shortcut file
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Remove-Item $shortcut -Force -ea 0 | Out-Null

  # Uninstall binary
  Uninstall-BinFile -Name $toolName
}

function VM-Write-Log-Exception {
  Param
  (
    [Parameter(Mandatory=$true)]
    [System.Management.Automation.ErrorRecord] $error_record
  )
  $msg = $error_record.Exception.Message
  $position_msg = $error_record.InvocationInfo.PositionMessage
  VM-Write-Log "ERROR" "[ERR] $msg`r`n$position_msg"
  throw $error_record
}