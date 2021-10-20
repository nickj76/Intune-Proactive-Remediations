
Try
{
    $LicenseState = Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.name -like "Windows*"}

    if ($LicenseState.LicenseStatus -eq 1 -or $LicenseState.LicenseStatus -eq 5)
    {
        #Exit 0 for machine licensed.
        Write-Host "Activated"            
        exit 0
    }
    else 
    {
        #Exit 1 for machine not licensed correctly
        Write-Host "NOT_Activated"
        exit 1        
    }

}

catch
{
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}