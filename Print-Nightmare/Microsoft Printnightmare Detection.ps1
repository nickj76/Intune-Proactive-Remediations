<#
   Code sourced from here:  https://thecollective.eu/blog/implement-workarounds-for-pinter-nightmare-with-mem/
   Code copyright of THIJS LECOMTE
   Code modified from here :  https://techcommunity.microsoft.com/t5/windows-security/printnightmare-for-administrators-trying-to-sum-up-the-current/m-p/2534399#M722
   Detection script for Printnightmare
   Code now in use 11-07-2021
#>



$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$RegKey = "NoWarningNoElevationOnInstall"
$RegValue = 1

try{
    
    if(Test-Path $RegPath)
        {
        #PointAndPrint exists - test for key
        $key = Get-ItemProperty -Path $RegPath | Select-Object -Property $RegKey -ErrorAction Stop
        Write-Host $key
        if($key)
            {
            #Key exists - default is for it to not exist
            Write-Host "Printnightmare Key value exists - remediate" 
            Exit 1
            }
        else
            {
            #Key doesnt exist so its in its default state - exit
            Write-Host "Printnightmare Key value doesnt exist - exit"
            Exit 0
            }
        }

        #PointAndPrint key doesnt exist
        Write-Output "PointAndPrint key doesnt exist - exit"
        Exit 0
    
    }
catch
    {
    Write-Host "Something has gone horriby wrong in your logic"
    Exit 0
    }