#Disable Java 
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bDisableJavaScript
#REG_DWORD value: 1

#Disable Flash
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bEnableFlash
#REG_DWORD value: 0

try
{
    
    $REG_JAVA = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"
    $REG_Value_Java = (Get-ItemProperty -Path $REG_JAVA).bDisableJavaScript
        
    $REG_Flash = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"
    $REG_Value_Flash = (Get-ItemProperty -Path $REG_Flash).bEnableFlash
    
    

    if (($REG_Value_Java -ne "1" -or $REG_Value_Flash -ne "0")){
        #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1

        write-host "Start remediation for disabeling Java in Adobe Reader DC"
        Remove-ItemProperty -Path $REG_JAVA -Name "bDisableJavaScript" -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $REG_JAVA -Name bDisableJavaScript -Value "1"  -PropertyType Dword

        write-host "Start remediation for disabeling flash in Adobe Reader DC"
        Remove-ItemProperty -Path $REG_Flash "bEnableFlash" -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $REG_Flash -Name bEnableFlash -Value "0"  -PropertyType Dword

    }
    else{
        #No matching certificates, do not remediate
        Write-Host "No_Match"        
        #exit 0
    }  } 
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    #exit 1
    }

