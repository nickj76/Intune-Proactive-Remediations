<#
.SYNOPSIS
    Display Repeated Toast Notifications in a single day 

.DESCRIPTION
	Notify the logged on user of a pending Windows Updates Installation
    
    
.PARAMETER Config
    Enter the required date into $TargetDate array that you want the toast notification to display .

.NOTES
    Filename: Toast-Notification-Detection.ps1
    Version: 1.2
    
    Version history:
    1.0.1 -   Add Synopsis, Description, Paramenter, notes etc.
    1.0   -   Script created.

#>
$Path = "HKLM:\Software\!ProactiveRemediations"
$Name = "Testmessagetoast"
$Value = 1

$TargetDate = (Get-Date -Day 10 -Month 09 -Year 2021).ToString("ddMMyyy")
$ClientDate = (Get-Date).ToString("ddMMyyy")

If (!($TargetDate -eq $ClientDate)){
    Write-Output "Remediation Target Date""$($TargetDate)"" not valid. Client date is $ClientDate. Remediation will not run."
    Exit 0
}

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Remediation not required."
        Exit 0
    } 
    Write-Output "Remediation required"
    Exit 1
} 
Catch {
    Write-Warning "Error Caught. Remediation will not run."
    Exit 0
}