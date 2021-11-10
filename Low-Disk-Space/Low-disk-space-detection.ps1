<#
.SYNOPSIS
    Low Disk Space Detection Proactive Remediation Script.

.DESCRIPTION
    Script to detect the amount of free space on the computer.
    
.PARAMETER Config
    Specify the minimum amount of free space as a number e.g. 0.10 = 10% or 0.70 = 70%  
    e.g.
    if (($systemDrive.FreeSpace/$systemDrive.Size) -le '0.10')

.NOTES
    Filename: Low-disk-space-detection.ps1
    Version: 1.1
     
    Version history:

    1.1   -   Production version
    1.0.1 -   Add Synopsis, Description, Paramenter, notes, and set minimum percentage of free space.
    1.0   -   Script created

#>

$os = Get-CimInstance Win32_OperatingSystem
$systemDrive = Get-CimInstance Win32_LogicalDisk -Filter "deviceid='$($os.SystemDrive)'"
if (($systemDrive.FreeSpace/$systemDrive.Size) -le '0.10') {
    Write-Output "Disk space is considered low. Script is exiting with 1 indicating error"
    exit 1
}
else {
    Write-Output "Disk space is OK."
    exit 0
}