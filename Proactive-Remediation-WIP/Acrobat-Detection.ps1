<#
.SYNOPSIS
    Update Acrobat Proactive Remediation Script.

.DESCRIPTION
    Script to detect if Acrobat is installed on the computer.
    
.NOTES
    Filename: acrobat-detection.ps1
    Version: 1.1
     
    Version history:

    1.1   -   Production version
    1.0.1 -   Add Synopsis, Description, Paramenter, notes, and set minimum percentage of free space.
    1.0   -   Script created

#>

Try
{  

    $CurrentReaderVersion = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe' 

    if ($CurrentReaderVersion -eq 'True') {
        Write-Host "Acrobat is installed"
        exit 1
        }
        else {
            #No remediation required    
            Write-Host "Acrobat is not installed"
            exit 0
        }  
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Error $errMsg
        exit 1
    }