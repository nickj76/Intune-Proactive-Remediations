# Based on https://sccmentor.com/2021/01/11/using-proactive-remediations-to-remove-google-chrome/
# Thank you.

try
{  

$chromeInstalled = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'

if ($chromeInstalled -eq 'True') {
    Write-Host "Google Chrome is installed locally"
    exit 1
    }
    else {
        #No remediation required    
        Write-Host "Google Chrome is not installed locally"
        exit 0
    }  
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    # exit 1
}
