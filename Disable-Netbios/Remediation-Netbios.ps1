$Path = "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\tcpip*"
$Name = "NetbiosOptions"
$Type = "DWORD"
$Value = 2

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value