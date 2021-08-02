<#
   Remediation for Windows 10 ASR Settings
   Three ways of doing this inside the test tenant
    1.  Set the registry key which appears to be instantaneous
    2.  Use the Set-MpPreference command
    3.  Use ADMX custom policy in MDM as Intune is already set to configure ASR
    4.  Force a resync of the entire device - may be better, but not guaranteed
    Updated 2021-07-28
#>

#SET VARIABLES


#ACTUAL CODE

try
    {
    Get-ScheduledTask | Where-Object {$_.TaskName -eq ‘PushLaunch’} | Start-ScheduledTask
    exit 0
    }
catch
    {
    Write-Error "Impossible Error"
    exit 0
    }