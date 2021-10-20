$Chrome = Get-Package -Name "Google Chrome" -ErrorAction SilentlyContinue
$Version = $Chrome.Version

try {
    $ErrorActionPreference = "SilentlyContinue"
    if ($Version -ge "95.0.4638.54"){
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