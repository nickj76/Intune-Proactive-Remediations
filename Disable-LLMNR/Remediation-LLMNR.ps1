$Path1 ="HKLM:\Software\policies\Microsoft\Windows NT"
$Path = "HKLM:\Software\policies\Microsoft\Windows NT\DNSClient"
$Name = "EnableMulticast"
$Type = "DWORD"
$Value = 0


$DNSclient = (Get-ItemProperty $path1).psobject.properties.name -contains "dnsclient"

If ($DNSclient -eq $false) 
       {
            New-Item -Path $Path
        }

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value