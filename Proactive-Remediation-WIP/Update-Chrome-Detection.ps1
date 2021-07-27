<#
.SYNOPSIS
    Remove Google Chrome Proactive Remediation Script.

.DESCRIPTION
    Script to detect if Google Chrome installed on the computer.
    
.NOTES
    Filename: Remove-Chrome-detection.ps1
    Version: 1.1
     
    Version history:

    1.1   -   Production version
    1.0.1 -   Add Synopsis, Description, Paramenter, notes, and set minimum percentage of free space.
    1.0   -   Script created

#>

Try
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