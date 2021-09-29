try
{  

$chromeInstalled = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'

if ($chromeInstalled -eq 'True') {
    Write-Host "Google Chrome is installed"
    exit 1
    }
    else {
        #No remediation required    
        Write-Host "Google Chrome is not installed"
        exit 0
    }  
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}