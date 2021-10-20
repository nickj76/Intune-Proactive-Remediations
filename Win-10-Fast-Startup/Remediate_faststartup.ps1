$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Name = "HiberbootEnabled"
$Type = "DWORD"
$Value = "0"
If (!(Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
    New-ItemProperty -Path $Path -Name $Name -Value $value -PropertyType $Type -Force | Out-Null
} else {
    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value 
}