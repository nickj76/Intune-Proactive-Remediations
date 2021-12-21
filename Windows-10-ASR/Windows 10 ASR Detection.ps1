<#
  There are now 16 rules to be configured
  Previous script was failing and was not correctly going into remediation
  Using script here: https://github.com/anthonws/MDATP_PoSh_Scripts/blob/master/ASR/ASR_Analyzer_v2.2.ps1
  Logic: If there are not 16 rules in total go straight into remediation
  Script has been updated to create a logfile on the machine
  This logfile can then be pulled via Live response within the M365 Defender portal assuming it is on without resorting to Diagnostics
#>


#VARIABLES


$RulesIds = Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Ids
$RulesActions = Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Actions


$RulesIdsArray = @()
$RulesIdsArray += $RulesIds

$counter = 0
$TotalNotConfigured = 0
$TotalAudit = 0
$TotalBlock = 0


#LOG NAME

$LogName = "C:\Temp\ASR-Verification.Log"


Function Tee-Log 
    { #writes to a file the output that you designate
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)]
            $Input,
          [Parameter(Mandatory = $true)]
            $FilePath,
        [switch]$Silent)
    if($Silent)
        {
        $Input | Out-File -FilePath $LogName -Append
        } 
    else 
        {
        $Input | Tee-Object -FilePath $LogName -Append
        }
    }


If (! (Test-Path $LogName))
    {
    # If path does not exists it should be created
    try{
        $tmpLogPath = $LogName
        if ($tmpLogPath -NotMatch '[\\\/]$') 
            { 
            $tmpLogName = ($tmpLogPath -split '[\\\/]')[-1]
            $tmpLogPath = $tmpLogPath -replace "$tmpLogName`$"
            } 
         else 
            {
            $tmpLogName = 'ASR-Verification.Log'
            }

        if (! (Test-Path $tmpLogPath)) 
            {
            New-Item -Path $tmpLogPath -Force -ItemType Directory | Out-Null
            }
            New-Item -Path "$tmpLogPath\$tmpLogName" -Force -ItemType File | Out-Null

        $LogName = "$tmpLogPath\$tmpLogName"
        } 
     catch 
        {
        Throw "Log file '$LogName' does not exists and cannot be created. Error: $_"
        }
    }


#write the following values to the log file as a seperation 

"========================================== DEVICE ========================================" | Tee-Log -FilePath $LogName -Silent:$Passthru
"$(get-date -format u)  :  INFO  : ComputerName: $($Env:ComputerName) VERSION 4" | Tee-Log -FilePath $LogName -Silent:$Passthru
"==========================================================================================" | Tee-Log -FilePath $LogName -Silent:$Passthru




ForEach ($i in $RulesActions)
    {
    If ($RulesActions[$counter] -eq 0)
        {$TotalNotConfigured++}
    ElseIf ($RulesActions[$counter] -eq 1)
        {$TotalBlock++}
    ElseIf ($RulesActions[$counter] -eq 2)
        {$TotalAudit++}
    $counter++
    }

#Write to file

"====================================== ASR Summary ======================================" | Tee-Log -FilePath $LogName -Silent:$Passthru
"=> There's $(($RulesIds).Count) rules configured" | Tee-Log -FilePath $LogName -Silent:$Passthru
"=> $TotalNotConfigured in Disabled Mode ** $TotalAudit in Audit Mode ** $TotalBlock in Block Mode" | Tee-Log -FilePath $LogName -Silent:$Passthru
"" | Tee-Log -FilePath $LogName -Silent:$Passthru
"====================================== ASR Rules ======================================" | Tee-Log -FilePath $LogName -Silent:$Passthru

$counter = 0

ForEach ($j in $RulesIds)
    {
    ## Convert GUID into Rule Name
     If ($RulesIdsArray[$counter] -eq "56a863a9-875e-4185-98a7-b882c64b5ce5"){$RuleName = "Abuse of exploited vulnerable signed drivers"}
    ElseIf ($RulesIdsArray[$counter] -eq "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c"){$RuleName = "Adobe Reader from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "D4F940AB-401B-4EFC-AADC-AD5F3C50688A"){$RuleName = "Office applications from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2"){$RuleName = "Credential stealing from the Windows local security authority subsystem (lsass.exe)"}
    ElseIf ($RulesIdsArray[$counter] -eq "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550"){$RuleName = "Executable content from email client and webmail"}
    ElseIf ($RulesIdsArray[$counter] -eq "01443614-cd74-433a-b99e-2ecdc07bfc25"){$RuleName = "Executable files from running unless they meet a prevalence, age, or trusted list criteria"}
    ElseIf ($RulesIdsArray[$counter] -eq "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC"){$RuleName = "Execution of potentially obfuscated scripts"}
    ElseIf ($RulesIdsArray[$counter] -eq "D3E037E1-3EB8-44C8-A917-57927947596D"){$RuleName = "JavaScript or VBScript from launching downloaded executable content"}
    ElseIf ($RulesIdsArray[$counter] -eq "3B576869-A4EC-4529-8536-B80A7769E899"){$RuleName = "Office applications from creating executable content"}
    ElseIf ($RulesIdsArray[$counter] -eq "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84"){$RuleName = "Office applications from injecting code into other processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "26190899-1602-49e8-8b27-eb1d0a1ce869"){$RuleName = "Office communication applications from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "e6db77e5-3df2-4cf1-b95a-636979351e5b"){$RuleName = "Persistence through WMI event subscription"}
    ElseIf ($RulesIdsArray[$counter] -eq "d1e49aac-8f56-4280-b9ba-993a6d77406c"){$RuleName = "Process creations originating from PSExec and WMI commands"}
    ElseIf ($RulesIdsArray[$counter] -eq "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4"){$RuleName = "Untrusted and unsigned processes that run from USB"}
    ElseIf ($RulesIdsArray[$counter] -eq "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B"){$RuleName = "Win32 API calls from Office macro"}
    ElseIf ($RulesIdsArray[$counter] -eq "c1db55ab-c21a-4637-bb3f-a12568109d35"){$RuleName = "Use Advanced protection against ransomware"}

    ## Check the Action type
    If ($RulesActions[$counter] -eq 0){$RuleAction = "Disabled"}
    ElseIf ($RulesActions[$counter] -eq 1){$RuleAction = "Block"}
    ElseIf ($RulesActions[$counter] -eq 2){$RuleAction = "Audit"}

    ## Output Rule Id, Name and Action

    "=> $($RulesIdsArray[$counter])  ** Action:$RuleAction --- $RuleName " | Tee-Log -FilePath $LogName -Silent:$Passthru
    $counter++

    }

try{
    
    If ($TotalBlock -eq 16)
        {
        "ASR Rules are compliant" | Tee-Log -FilePath $LogName -Silent:$Passthru
        exit 0
        }
    else
        {
        "ASR Rules are not compliant - group policy update called" | Tee-Log -FilePath $LogName -Silent:$Passthru
        exit 1
        }
     }
catch
    {
     "ASR Rules error - refer to system admin" | Tee-Log -FilePath $LogName -Silent:$Passthru
      exit 1
    }