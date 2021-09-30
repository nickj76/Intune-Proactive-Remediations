<# 
.SYNOPSIS
   Fix Blank SaveAs screen in Adobe Acrobat Reader DC.

.DESCRIPTION
   Detect if the "Show online storage when saving files" registry entry is present on a device .

.EXAMPLE
   PS C:\> .\Detection.ps1
   Save the file to your hard drive with a .PS1 extention and run the file from an elavated PowerShell prompt.

.FUNCTIONALITY
   PowerShell v1+
#>

$Path = "HKCU:\Software\Adobe\Acrobat Reader\DC\AVGeneral"
$Name = "bToggleCustomSaveExperience"
$Type = "DWORD"
$Value = 0

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}