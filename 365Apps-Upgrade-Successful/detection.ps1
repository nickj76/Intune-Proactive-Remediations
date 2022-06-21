
Try
{
    if (Test-Path -Path C:\logfiles\365AppsUpgrade-Reboot.txt -PathType Leaf)
    {
        #Exit 0 for 365 Apps installed.
        Write-Host "Installed"            
        exit 0
    }
    else 
    {
        #Exit 1 for 365 Apps not installed
        Write-Host "Not Installed"
        exit 1        
    }

}

catch
{
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}