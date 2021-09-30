<# 
.SYNOPSIS
   Fix Blank Open screen in Adobe Acrobat Reader DC.

.DESCRIPTION
   Creates registry entry to untick "Show online storage when Open files".

.EXAMPLE
   PS C:\> .\Remediation.ps1
   Save the file to your hard drive with a .PS1 extention and run the file from an elavated PowerShell prompt.

.FUNCTIONALITY
   PowerShell v4+
#>

$Path1 = "HKCU:\Software\Adobe\Adobe Acrobat\DC\AVGeneral\"
$Name1 = "bToggleCustomOpenExperience"
$Type1 = "DWORD"
$Value1 = "1"

IF(!(Test-Path $Path1))

{

New-Item -Path $Path1 -Force | Out-Null

Set-ItemProperty -Path $Path1 -Name $Name1 -Type $Type1 -Value $Value1 | Out-Null }

ELSE {

   Set-ItemProperty -Path $Path1 -Name $Name1 -Type $Type1 -Value $Value1 | Out-Null }