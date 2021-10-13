$Chrome = Get-Package -Name "Google Chrome" -ErrorAction SilentlyContinue
$Version = $Chrome.Version

try {
    $ErrorActionPreference = "SilentlyContinue"
    if ($Version -eq "94.0.4606.81"){
        Write-Host "Chrome does not need updating"
        exit 0
    }
    else {
        Write-Host "Chrome needs updating"
        exit 1  
    }
}
catch {
    $errMsg = $_.Exception.Message
    write-host $errMsg
    exit 1
}