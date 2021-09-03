<#
.SYNOPSIS
    Display Repeated Toast Notifications in a single day 

.DESCRIPTION
	Notify the logged on user of a pending Windows Updates Installation
    
    
.PARAMETER Config
    Change #Toast Message as appropriate to meet requirements.
    Adding multiple times to the $ToastTimes array will pop the toast at regular intervals.

.NOTES
    Filename: Toast-Notification-Remediation.ps1
    Version: 1.4
    
    Version history:
	1.3   -   Completed converting images to base64 code meaning everything is contained within the script.
	1.2	  -   Incorporated Heroimage as base64 code and removed linking images and downloading of images from script.	
    1.1   -   Added links to required images.
    1.0.1 -   Add Synopsis, Description, Paramenter, notes etc.
    1.0   -   Script created.

#>


Param
(
    [Parameter(Mandatory = $False)]
    [String]$ToastGUID
)

#region ToastCustomisation

#Create Toast variables, 24HR Time Format
$ToastTimes = @("15:00", "16:00", "17:00")

#Toast Message
$ToastTitle = "an Important Update is Scheduled"
$ToastText = "You MUST leave your computer on after 17:00 today. Failure to do so will result in a delay accessing your computer tomorrow"
$Signature = "IT Services, University of Surrey."

#Toast Images

# Picture Base64
# Create the picture object from a base64 code - HeroImage.

$Picture_Base64 = "/9j/4AAQSkZJRgABAQEASABIAAD/4QBoRXhpZgAATU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAAExAAIAAAARAAAATgAAAAAAAABIAAAAAQAAAEgAAAABcGFpbnQubmV0IDQuMi4xNQAA/9sAQwACAQEBAQECAQEBAgICAgIEAwICAgIFBAQDBAYFBgYGBQYGBgcJCAYHCQcGBggLCAkKCgoKCgYICwwLCgwJCgoK/9sAQwECAgICAgIFAwMFCgcGBwoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoK/8AAEQgAtAFsAwEhAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A/fyigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKCcDJoAAcjIooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAK8z/aB+J2neEdItZotcuFh07xBYf8JFDpbFrpIH3tFGFX5sySpGu0clGbsc187xVmVPK8jq1pScdOnxWXvS5f7ygpNW100OrBUXWxEY2v+XZX8rtXOh+D2na/pXw+t7jxfC1vqWoXVzqF7btJu+zPcTvMIc/7AcJx/drmvhn8bLvx98RrjTY5y9ncfav7N0+1gU/Z7W3maE3lzITkGaVWWOMD7qknPJHk/wBq4nKqeV4KrpUqqPOt27KMZJek5qTf8kZ2N/YxrutUjtHb8WvwVvVo9Qor7g84KKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigAooAKKACigDzr47fFzUfh9bzaPpCRR3NxoFzcwXkx+WCUXFpbRtt6Moa63tz0T3rxm68Q2Nl8YPE2sWH2/xPrv8AwkEtp4K8PRrHxqEVpBDc6lNkbFRGQIruMLtfaOSR+J8dZ77TOI4WV2qFSm4042vUm4VOSOver7JduW7ejZ9FluF5aDmvtJpt9FdXf/gN33vaxlaf8Yf2iP2jNM03wa2uxaPcanqFqGsdL8JzlharKrtetdSkxKgC7l2ZLMFXAzX0d8Gfgh4M+CWgzaV4YSee4vZvP1LU71w1xdyerEAAAZOFAAGT3JJnw5hmnF2af6zZxK86cVCnBQcIQlJNztze9NqLS578r5pJXsmGbOhgKP1PDrRu7d020rW20Sur230R2VFftx86Fcr8cviJffCL4MeLfivpvh9dWn8MeGb7VotLkvPs4vGt4Hm8nzdj+Xu2bd2xsZzg9KunH2lSMb2u0vvIqS9nTcktk2eZ/wDBOD9tC8/b/wD2VdH/AGoJ/hgvhGHW9QvYLPR/7b/tBhHbzvAXaTyYcEvG/wAu3gAHJzgcr+1V/wAFE9b/AGaf21vg5+yDafA6PXk+L1wYrfxI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"
$HeroImgName = "$env:TEMP\HeroPicture.png"
[byte[]]$Bytes = [convert]::FromBase64String($Picture_Base64)
[System.IO.File]::WriteAllBytes($HeroImgName,$Bytes)
# Picture Base64 end

# Picture Base64
# Create the picture object from a base64 code - BadgeImage.

$Picture1_Base64 = "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"
$BadgeImgName = "$env:TEMP\badgePicture.png"
[byte[]]$Bytes = [convert]::FromBase64String($Picture1_Base64)
[System.IO.File]::WriteAllBytes($BadgeImgName,$Bytes)
# Picture Base64 end

#ToastScenario: Alarm, Reminder
$ToastScenario = "reminder"

#ToastDuration: Short = 7s, Long = 25s
$ToastDuration = "long"

#endregion ToastCustomisation

#region ToastRunningValues

#Set Unique GUID for the Toast
If (!($ToastGUID)) {
    $ToastGUID = ([guid]::NewGuid()).ToString().ToUpper()
}

#Format Time
$TaskTimes = @()
Foreach ($ToastTime in $ToastTimes) {
    $ToastTimeToUse = ([datetime]::ParseExact($ToastTime, "HH:mm", $null))
    $TaskTimes += $ToastTimeToUse
}

#Current Directory
$ScriptPath = $MyInvocation.MyCommand.Path
$CurrentDir = Split-Path $ScriptPath

#Set Toast Path to Temp Directory
$ToastPath = (Join-Path $ENV:Windir -ChildPath "temp\$($ToastGUID)")

#Set Toast PS File Name
$ToastPSFile = $MyInvocation.MyCommand.Name

#endregion ToastRunningValues

#region ScriptFunctions

# Toast function
function Display-ToastNotification {

    #Check for Constrained Language Mode
    $PSExecutionContext = $ExecutionContext.SessionState.LanguageMode

    If ($PSExecutionContext -eq "ConstrainedLanguage") {   
        Write-Warning "Execution Context is set to ConstrainedLanguage. Toast will not run. Ensure your AppLocker policy allow scripts to run from ""$($ToastPath)"" - or even better, sign the script and trust the publisher."
        Exit 1
    }

    #Force TLS1.2 Connection
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    #Set COM App ID > To bring a URL on button press to focus use a browser for the appid e.g. MSEdge
    #$LauncherID = "Microsoft.SoftwareCenter.DesktopToasts"
    $LauncherID = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"
    #$Launcherid = "MSEdge"
	
    #Dont Create a Scheduled Task if the script is running in the context of the logged on user, only if SYSTEM fired the script i.e. Deployment from Intune/ConfigMgr
    If (([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name -eq "NT AUTHORITY\SYSTEM") {
		     
        #Prepare to stage Toast Notification Content in Toast Folder
        Try {
			
            #Create TEMP folder to stage Toast Notification Content in %TEMP% Folder
            New-Item $ToastPath -ItemType Directory -Force -ErrorAction Continue | Out-Null
            $ToastFiles = Get-ChildItem $CurrentDir -Filter *.ps1 -Recurse

            #Copy Toast Files to Toat TEMP folder
            ForEach ($ToastFile in $ToastFiles) {
                Copy-Item -Path (Join-Path -Path $CurrentDir -ChildPath $ToastFile) -Destination $ToastPath -ErrorAction Continue
            }
        }
        Catch {
            Write-Warning $_.Exception.Message
        }
		
        #Created Scheduled Tasks to run as Logged on User

        #New ToastFile to run for Scheduled Task

        $NewToastFile = Join-Path -Path $ToastPath -ChildPath $ToastPSFile

        #Create Trigger for eacdh time in $ToastTime
        $Task_Triggers = @()
        Foreach ($TaskTime in $TaskTimes) {
            $Task_Expiry = $TaskTime.AddSeconds(21600).ToString('s') #Task Expires after 6 hours
            $Task_Trigger = New-ScheduledTaskTrigger -Once -At $TaskTime
            $Task_Trigger.EndBoundary = $Task_Expiry
            $Task_Triggers += $Task_Trigger
        }
        
        $Task_Principal = New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" -RunLevel Limited
        $Task_Settings = New-ScheduledTaskSettingsSet -Compatibility V1 -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 600) -AllowStartIfOnBatteries
        $Task_Action = New-ScheduledTaskAction -Execute "C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -File ""$NewToastFile"" -ToastGUID ""$ToastGUID"""
        $New_Task = New-ScheduledTask -Description "Toast_Notification_$($ToastGuid) Task for user notification. Title: $($ToastTitle) :: Event:$($ToastText) :: Source Path: $($ToastPath) " -Action $Task_Action -Principal $Task_Principal -Trigger $Task_Triggers -Settings $Task_Settings
        Register-ScheduledTask -TaskName "Toast_Notification_$($ToastGuid)" -InputObject $New_Task

        #Create Reg key to flag Proactive Remediation as successful
        New-Item -Path "HKLM:\Software\!ProactiveRemediations" -ErrorAction SilentlyContinue
        New-ItemProperty -Path "HKLM:\Software\!ProactiveRemediations" -Name "20H2NotificationSchTaskCreated" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    }
	
    #Run the toast if the script is running in the context of the Logged On User
    If (!(([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name -eq "NT AUTHORITY\SYSTEM")) {
		
        $Log = (Join-Path $ENV:Windir "Temp\$($ToastGuid).log")
        Start-Transcript $Log

        #Get logged on user DisplayName
        #Try to get the DisplayName for Domain User
        $ErrorActionPreference = "Continue"
		
        Try {
            Write-Output "Trying Identity LogonUI Registry Key for Domain User info..."
            Get-Itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnDisplayName" -ErrorAction Stop | out-null
            $User = Get-Itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnDisplayName" | Select-Object -ExpandProperty LastLoggedOnDisplayName -ErrorAction Stop | out-null
			
            If ($Null -eq $User) {
                $Firstname = $Null
            }
            else {
                $DisplayName = $User.Split(" ")
                $Firstname = $DisplayName[0]
            }
        }
        Catch [System.Management.Automation.PSArgumentException] {
            "Registry Key Property missing"
            Write-Warning "Registry Key for LastLoggedOnDisplayName could not be found."
            $Firstname = $Null
        }
        Catch [System.Management.Automation.ItemNotFoundException] {
            "Registry Key itself is missing"
            Write-Warning "Registry value for LastLoggedOnDisplayName could not be found."
            $Firstname = $Null
        }
		
        #Try to get the DisplayName for Azure AD User
        If ($Null -eq $Firstname) {
            Write-Output "Trying Identity Store Cache for Azure AD User info..."
            Try {
                $UserSID = (whoami /user /fo csv | ConvertFrom-Csv).Sid
                $LogonCacheSID = (Get-ChildItem HKLM:\SOFTWARE\Microsoft\IdentityStore\LogonCache -Recurse -Depth 2 | Where-Object { $_.Name -match $UserSID }).Name
                If ($LogonCacheSID) {
                    $LogonCacheSID = $LogonCacheSID.Replace("HKEY_LOCAL_MACHINE", "HKLM:")
                    $User = Get-ItemProperty -Path $LogonCacheSID | Select-Object -ExpandProperty DisplayName -ErrorAction Stop
                    $DisplayName = $User.Split(" ")
                    $Firstname = $DisplayName[0]
                }
                else {
                    Write-Warning "Could not get DisplayName property from Identity Store Cache for Azure AD User"
                    $Firstname = $Null
                }
            }
            Catch [System.Management.Automation.PSArgumentException] {
                Write-Warning "Could not get DisplayName property from Identity Store Cache for Azure AD User"
                Write-Output "Resorting to whoami info for Toast DisplayName..."
                $Firstname = $Null
            }
            Catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning "Could not get SID from Identity Store Cache for Azure AD User"
                Write-Output "Resorting to whoami info for Toast DisplayName..."
                $Firstname = $Null
            }
            Catch {
                Write-Warning "Could not get SID from Identity Store Cache for Azure AD User"
                Write-Output "Resorting to whoami info for Toast DisplayName..."
                $Firstname = $Null
            }
        }
		
        #Try to get the DisplayName from whoami
        If ($Null -eq $Firstname) {
            Try {
                Write-Output "Trying Identity whoami.exe for DisplayName info..."
                $User = whoami.exe
                $Firstname = (Get-Culture).textinfo.totitlecase($User.Split("\")[1])
                Write-Output "DisplayName retrieved from whoami.exe"
            }
            Catch {
                Write-Warning "Could not get DisplayName from whoami.exe"
            }
        }
		
        #If DisplayName could not be obtained, leave it blank
        If ($Null -eq $Firstname) {
            Write-Output "DisplayName could not be obtained, it will be blank in the Toast"
        }

        #Get Hour of Day and set Custom Hello
        $Hour = (Get-Date).Hour
        If ($Hour -lt 12) { $CustomHello = "Good Morning, $ToastTitle" }
        ElseIf ($Hour -gt 16) { $CustomHello = "Good Evening, $ToastTitle" }
        Else { $CustomHello = "Good Afternoon, $ToastTitle" }
		
        #Load Assemblies
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
		
        #Build XML ToastTemplate 
        [xml]$ToastTemplate = @"
<toast duration="$ToastDuration" scenario="$ToastScenario">
    <visual>
        <binding template="ToastGeneric">
            <text>$CustomHello</text>
            <text>$ToastText</text>
            <text placement="attribution">$Signature</text>
            <image placement="hero" src="$HeroImgName"/>
            <image placement="appLogoOverride" hint-crop="circle" src="$BadgeImgName"/>
        </binding>
    </visual>
    <audio src="ms-winsoundevent:notification.default"/>
</toast>
"@
		
        #Build XML ActionTemplate 
        [xml]$ActionTemplate = @"
<toast>
    <actions>
        <action arguments="dismiss" content="Dismiss" activationType="system"/>
    </actions>
</toast>
"@
		
        #Define default actions to be added $ToastTemplate
        $Action_Node = $ActionTemplate.toast.actions
		
        #Append actions to $ToastTemplate
        [void]$ToastTemplate.toast.AppendChild($ToastTemplate.ImportNode($Action_Node, $true))
		
        #Prepare XML
        $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
        $ToastXml.LoadXml($ToastTemplate.OuterXml)
		
        #Prepare and Create Toast
        $ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($LauncherID).Show($ToastMessage)
		
        Stop-Transcript
    }
}
#endregion RegionName

#region ScriptRunningCode
	
Display-ToastNotification

#Endregion ScriptRunningCode