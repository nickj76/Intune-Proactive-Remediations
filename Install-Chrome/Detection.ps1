try {
    $ErrorActionPreference = "SilentlyContinue"
    if(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'){
        Write-Host "Chrome already installed"
        exit 0
    }
    else {
        Write-Host "Chrome needs installed"
        exit 1  
    }
}
catch {
    $errMsg = $_.Exception.Message
    write-host $errMsg
    exit 1
}