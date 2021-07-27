function Display-ToastNotification() {
	$Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
	$Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
	# Load the notification into the required format
	$ToastXML = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
	$ToastXML.LoadXml($Toast.OuterXml)
	
	# Display the toast notification
	try {
		[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($App).Show($ToastXml)
	} catch {
		Write-Output -Message 'Something went wrong when displaying the toast notification' -Level Warn
		Write-Output -Message 'Make sure the script is running as the logged on user' -Level Warn
	}
}

# Check for required entries in registry for when using Powershell as application for the toast
# Register the AppID in the registry for use with the Action Center, if required
$RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings'
$App = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

# Multiple Battery handling
$BatteryInstances = Get-WmiObject -Namespace "ROOT\WMI" -Class "BatteryStatus" | Select-Object -ExpandProperty InstanceName


ForEach($BatteryInstance in $BatteryInstances){

    # Set Variables for health check

    $BatteryDesignSpec = Get-WmiObject -Namespace "ROOT\WMI" -Class "BatteryStaticData" | Where-Object -Property InstanceName -EQ $BatteryInstance | Select-Object -ExpandProperty DesignedCapacity
    $BatteryFullCharge = Get-WmiObject -Namespace "ROOT\WMI" -Class "BatteryFullChargedCapacity" | Where-Object -Property InstanceName -EQ $BatteryInstance | Select-Object -ExpandProperty FullChargedCapacity

    # Fall back WMI class for Microsoft Surface devices
    if ($BatteryDesignSpec -eq $null -or $BatteryFullCharge -eq $null -and ((Get-WmiObject -Class Win32_BIOS | Select-Object -ExpandProperty Manufacturer) -match "Microsoft")) {
	
        # Attempt to call WMI provider
	    if (Get-WmiObject -Class MSBatteryClass -Namespace "ROOT\WMI") {
		    $MSBatteryInfo = Get-WmiObject -Class MSBatteryClass -Namespace "root\wmi" | Where-Object -Property InstanceName -EQ $BatteryInstance | Select-Object FullChargedCapacity, DesignedCapacity
		
		    # Set Variables for health check
		    $BatteryDesignSpec = $MSBatteryInfo.DesignedCapacity
		    $BatteryFullCharge = $MSBatteryInfo.FullChargedCapacity
	    }
    }

    # Determine battery replacement required
    [int]$CurrentHealth = ($BatteryFullCharge/$BatteryDesignSpec) * 100

    # Setting image variables
    $LogoImageUri = "YOURLOGIMAGEURLHERE"
    $HeroImageUri = "YOURHEROIMAGEURLHERE"
    $LogoImage = "$env:TEMP\ToastLogoImage.png"
    $HeroImage = "$env:TEMP\ToastHeroImage.png"
    $MinHealth = 40
    

    If($CurrentHealth -le $MinHealth){

        #Fetching images from uri
        Invoke-WebRequest -Uri $LogoImageUri -OutFile $LogoImage
        Invoke-WebRequest -Uri $HeroImageUri -OutFile $HeroImage

        #Defining the Toast notification settings
        #ToastNotification Settings
        $Scenario = 'reminder' # <!-- Possible values are: reminder | short | long -->

        # Load Toast Notification text
        $AttributionText = "MSEndpointMgr"
        $HeaderText = "Battery Replacement Required"
        $TitleText = "Your device battery health is currently operating at $CurrentHealth% of manufacturers specifications."
        $BodyText1 = "It is recommended that your battery is replaced as soon as possible."
        $BodyText2 = "Please contact IT and request a battery replacement. Thank you in advance."


        # Creating registry entries if they don't exists
                if (-NOT (Test-Path -Path "$RegPath\$App")) {
	    New-Item -Path "$RegPath\$App" -Force
	    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD'
        }

        # Make sure the app used with the action center is enabled
            if ((Get-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -ErrorAction SilentlyContinue).ShowInActionCenter -ne '1') {
	    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD' -Force
        }


# Formatting the toast notification XML
[xml]$Toast = @"
<toast scenario="$Scenario">
    <visual>
    <binding template="ToastGeneric">
        <image placement="hero" src="$HeroImage"/>
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
        <text placement="attribution">$AttributionText</text>
        <text>$HeaderText</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true" >$TitleText</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$BodyText1</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$BodyText2</text>
            </subgroup>
        </group>
    </binding>
    </visual>
    <actions>
        <action activationType="system" arguments="dismiss" content="$DismissButtonContent"/>
    </actions>
</toast>
"@

        #Send the notification
        Display-ToastNotification
        Exit 0
    }
else{$CurrentHealth}
}