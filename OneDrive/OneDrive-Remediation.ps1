<#
   There following detection script was taken from here
   https://letsconfigmgr.com/mem-automatic-syncing-of-onedrive-shared-libs-via-intune/

   There is a registry key that decreases the delay for end-users to see their administratively assigned libraries 
   via the OneDrive sync client, however, this key does get removed upon every reboot, I will show you how you can use
   the power of Proactive Remediations via Microsoft Intune to set detect if this registry key exists and 
   if not, create it, on a recurring schedule

#>


$Path = "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1"
$Name = "Timerautomount"
$Type = "QWORD"
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value 
