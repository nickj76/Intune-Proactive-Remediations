#region Print servers
$printServers = @(
    "printservice.surrey.ac.uk"
    "WinPrint.surrey.ac.uk"
)
#endregion
#region PnP retrictions
$hklmKeys = @(
    [PSCustomObject]@{
        Name  = "Restricted"
        Type  = "DWORD"
        Value = "1"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
    [PSCustomObject]@{
        Name  = "TrustedServers"
        Type  = "DWORD"
        Value = "1"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
    [PSCustomObject]@{
        Name  = "InForest"
        Type  = "DWord"
        Value = "0"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
    [PSCustomObject]@{
        Name  = "NoWarningNoElevationOnInstall"
        Type  = "DWord"
        Value = "1"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
    [PSCustomObject]@{
        Name  = "UpdatePromptSettings"
        Type  = "DWord"
        Value = "2"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
    [PSCustomObject]@{
        Name  = "ServerList"
        Type  = "String"
        Value = $printServers -join ";"
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
    }
)
#endregion

#region Package PnP Approved Servers
$hklmKeys += [PSCustomObject]@{
    Name  = "PackagePointAndPrintServerList"
    Type  = "DWORD"
    Value = "1"
    Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PackagePointAndPrint"
}
foreach ($p in $printServers) {
    $hklmKeys += [PSCustomObject]@{
        Name  = $p
        Type  = "String"
        Value = $p
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PackagePointAndPrint\ListofServers"
    }
}
#endregion

#region Functions
function Set-ComputerRegistryValues {
    param (
        [Parameter(Mandatory = $true)]
        [array]$RegistryInstance
    )
    try {
        foreach ($key in $RegistryInstance) {
            $keyPath = "$($key.Path)"
            if (!(Test-Path $keyPath)) {
                Write-Host "Registry path : $keyPath not found. Creating now." -ForegroundColor Green
                New-Item -Path $keyPath -Force | Out-Null
                Write-Host "Creating item property: $($key.Name)" -ForegroundColor Green
                New-ItemProperty -Path $keyPath -Name $key.Name -Value $key.Value -PropertyType $key.Type -Force
            }
            else {
                Write-Host "Creating item property: $($key.Name)" -ForegroundColor Green
                New-ItemProperty -Path $keyPath -Name $key.Name -Value $key.Value -PropertyType $key.Type -Force
            }
        }
    }
    catch {
        Throw $_.Exception.Message
    }
}
#endregion
Set-ComputerRegistryValues -RegistryInstance $hklmKeys