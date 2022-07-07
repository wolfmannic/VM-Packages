$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinDump'
$category = 'Networking Tools'

$exeUrl = 'https://www.winpcap.org/windump/install/bin/windump_3_9_5/WinDump.exe'
$exeSha256 = '2525041DCA2BD37240CCA59EB83FA1EC10A4A43716D324DC104DD39DB98D358F'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
