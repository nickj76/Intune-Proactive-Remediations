<#
   Code sourced from here:  https://thecollective.eu/blog/implement-workarounds-for-pinter-nightmare-with-mem/
   Code copyright of THIJS LECOMTE
   Code modified from here :  https://techcommunity.microsoft.com/t5/windows-security/printnightmare-for-administrators-trying-to-sum-up-the-current/m-p/2534399#M722
   Remediation script for Printnightmare
   Code now in use 11-07-2021
#>


$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$RegKey = "NoWarningNoElevationOnInstall"
$RegValue = 1

#Key already exists or otherwise wouldnt go to remediation - no need for testing
#Remove the key

try{
    Remove-ItemProperty -Path $RegPath -Name $RegKey -Value $RegValue -Force
    Write-Host "Key has been removed"

    Restart-Service -Name "Spooler" -force
    Write-Host "Spooler has been reset"
    }
catch
    {
    Write-Error "Something has gone horribly wrong"
    }