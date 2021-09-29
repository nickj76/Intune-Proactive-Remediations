# Start-Process Installers and Arguments
$Installer = "$env:ProgramFiles\Google\Chrome\Application\$ChromeVersion\Installer\chrmstp.exe"
$InstallerX86 = "${env:ProgramFiles(x86)}\Google\Chrome\Application\$ChromeVersion\Installer\chrmstp.exe"
$Arguements = "--uninstall --chrome --system-level --multi-install --force-uninstall"

$chromeInstalled = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe' -ErrorAction SilentlyContinue).'(Default)').VersionInfo
 $ChromeVersion = $chromeInstalled.ProductVersion

 # Check for x64 Chrome
 $Chromex64 = "C:\Program Files\Google\Chrome\Application\$ChromeVersion\Installer\chrmstp.exe"
 $FileExistsx64 = Test-Path $Chromex64

 # Check for x86 Chrome
 $Chromex86 = "C:\Program Files (x86)\Google\Chrome\Application\$ChromeVersion\Installer\chrmstp.exe"
 $FileExistsx86 = Test-Path $Chromex86

 # Remove x64 Chrome
 If ($FileExistsx64 -eq $True) {
    Start-Process $Installer $Arguements -Wait
 }
  
  # Remove x86 Chrome
 If ($FileExistsx86 -eq $True) {
    Start-Process $InstallerX86 $Arguements -Wait
 }