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