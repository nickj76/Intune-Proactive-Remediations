$Firefox = Get-Package -Name "Mozilla Firefox (x64 en-GB)" -ErrorAction SilentlyContinue
$Version = $Firefox.Version

try {
    $ErrorActionPreference = "SilentlyContinue"
    if ($Version -eq "93.0"){
        Write-Host "Firefox does not need updating."
        exit 0
    }
    else {
        Write-Host "Firefox needs updating."
        exit 1  
    }
}
catch {
    $errMsg = $_.Exception.Message
    write-host $errMsg
    exit 1
}