<# 
.SYNOPSIS
   Fix Blank SaveAs screen in Adobe Acrobat Reader DC.

.DESCRIPTION
   Creates registry entry to untick "Show online storage when saving files".

.EXAMPLE
   PS C:\> .\Remediation.ps1
   Save the file to your hard drive with a .PS1 extention and run the file from an elavated PowerShell prompt.

.FUNCTIONALITY
   PowerShell v4+
#>

$Path = "HKCU:\Software\Adobe\Adobe Acrobat\DC\AVGeneral\"
$Name = "bToggleCustomSaveExperience"
$Type = "DWORD"
$Value = "1"

IF(!(Test-Path $Path))

{

New-Item -Path $Path -Force | Out-Null

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value | Out-Null }

ELSE {

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value | Out-Null }