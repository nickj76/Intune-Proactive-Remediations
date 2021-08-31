<#	
	.NOTES

	.DESCRIPTION
		Monitors WMI values for hard disk health, helping you predict or detect
		anomalies and be preactive about hard disk replacement.
#>

#region ScriptVariables

# Define variables
$Organisation = "YOUR ORG DETAILS"
$MaxWearValue = 90
$MaxRWErrors = 100
$RegistryBase = "HKLM:\SOFTWARE\$Organisation\Monitoring\Disk Health"

# Obtain physical disk details
$Disks = Get-PhysicalDisk | Where-Object { $_.BusType -match "NVMe|SATA|SAS|ATAPI|RAID" }

#endregion ScriptVariables

#region ScriptFunctions

function Write-RegistryEntries {
	
	# Set disk registry path
	$RegistryPath = Join-Path -Path $RegistryBase -ChildPath "Disk $($Disk.DeviceID)"
	
	# Create disk registry key if not present
	if (-not (Test-Path -Path $RegistryPath)) {
		New-Item -Path $RegistryPath -Force | Out-Null
	}
	
	# Set registry values and warning message
	New-ItemProperty -Path $RegistryPath -Name "Friendly Name" -Value $($Disk.FriendlyName) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Health Status" -Value $DriveHealthState -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Media Type" -Value $DriveMediaType -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Wear" -Value $([int]($DiskHealth.Wear)) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Read Errors" -Value $([int]($DiskHealth.ReadErrorsTotal)) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Temperature Delta" -Value $DiskTempDelta -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Read Errors Uncorrected" -Value $($Disk.ReadErrorsUncorrected) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Read Errors Total" -Value $($Disk.ReadErrorsTotal) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Write Errors Uncorrected" -Value $([int]($DiskHealth.WriteErrorsUncorrected)) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Write Errors Total" -Value $([int]($DiskHealth.WriteErrorsTotal)) -PropertyType "String" -Force | Out-Null
	New-ItemProperty -Path $RegistryPath -Name "Output" -Value $OutputMsg -PropertyType "String" -Force | Out-Null
	
}

#endregion ScriptFunctions

#region ScriptRunningCode

# Create root registry key if not present
if (-not (Test-Path -Path $RegistryBase)) {
	New-Item -Path $RegistryBase -Force | Out-Null
}

# Loop through each disk
foreach ($Disk in ($Disks | Sort-Object DeviceID)) {
	# Set initial output variable state
	$OutputMsg = $null
	
	# Obtain disk health information from current disk
	$DiskHealth = Get-PhysicalDisk -FriendlyName $($Disk.FriendlyName) | Get-StorageReliabilityCounter | Select-Object -Property Wear, ReadErrorsTotal, ReadErrorsUncorrected, WriteErrorsTotal, WriteErrorsUncorrected, Temperature, TemperatureMax
	
	# Obtain media type
	$DriveDetails = Get-PhysicalDisk -FriendlyName $($Disk.FriendlyName) | Select-Object MediaType, HealthStatus
	$DriveMediaType = $DriveDetails.MediaType
	$DriveHealthState = $DriveDetails.HealthStatus
	$DiskTempDelta = [int]$($DiskHealth.Temperature) - [int]$($DiskHealth.TemperatureMax)
	
	# Obtain SMART failure information
	$DriveSMARTStatus = (Get-WmiObject -namespace root\wmi -class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue | Select-Object InstanceName, PredictFailure, Reason) | Where-Object { $_.PredictFailure -eq $true }
	
	# Create custom PSObject
	$DiskHealthState = new-object -TypeName PSObject
	
	# Create disk entry
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk Number" -Value $Disk.DeviceID
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "FriendlyName" -Value $($Disk.FriendlyName)
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "HealthStatus" -Value $DriveHealthState
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "MediaType" -Value $DriveMediaType
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk Wear" -Value $([int]($DiskHealth.Wear))
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) Read Errors" -Value $([int]($DiskHealth.ReadErrorsTotal))
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) Temperature Delta" -Value $DiskTempDelta
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) ReadErrorsUncorrected" -Value $($Disk.ReadErrorsUncorrected)
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) ReadErrorsTotal" -Value $($Disk.ReadErrorsTotal)
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) WriteErrorsUncorrected" -Value $($Disk.WriteErrorsUncorrected)
	$DiskHealthState | Add-Member -MemberType NoteProperty -Name "Disk $($Disk.DeviceID) WriteErrorsTotal" -Value $($Disk.WriteErrorsTotal)
	
	# Check for health, read failures, or temperature issues
	If ($DriveHealthState -ne "Healthy") {
		$OutputMsg = "Disk $($Disk.DeviceID) / $($Disk.FriendlyName) is in a $([string]$DriveHealthState.ToLower()) state"
	} elseif ($DriveSMARTStatus -gt $null) {
		$OutputMsg = "SMART predicted failure detected with reason code $($DriveSMARTStatus.Reason)"
	} elseif ([int]($DiskHealth.Wear) -ge $MaxWearValue) {
		$OutputMsg = "Disk failure likely on disk $($Disk.DeviceID) with media type $DriveMediaType. Current wear value is reading as $([int]($DiskHealth.Wear)), above the set threshold of 90%."
	} elseif ([int]($DiskHealth.ReadErrorsTotal) -ge $MaxRWErrors) {
		$OutputMsg = "A high number of disk read errors $([int]($DiskHealth.ReadErrorsTotal)) on disk $($Disk.DeviceID) with media type $DriveMediaType"
	} elseif ([int]($DiskHealth.WriteErrorsTotal) -ge $MaxRWErrors) {
		$OutputMsg = "A high number of disk write errors $([int]($DiskHealth.WriteErrorsTotal)) on disk $($Disk.DeviceID) with media type $DriveMediaType"
	} elseif ($([int]($DiskHealth.Temperature)) -gt $([int]($DiskHealth.TemperatureMax)) -and ([int]($DiskHealth.TemperatureMax)) -gt 0) {
		$OutputMsg = "Disk $($Disk.NumDeviceIDber) is currently running $DiskTempDelta above the maximum temperature rating $($Disk.TemperatureMax) for the drive."
	} else {
		$OutputMsg = "Disk $($Disk.DeviceID) is in a healthy state. No action required."
	}
	
	# Write entries to Registry
	Write-RegistryEntries
}

# Set remiediation value based on disk issues
$DriveHealthIssue = [boolean](Get-ChildItem -Path $RegistryBase -Recurse | Get-ItemProperty | Where-Object { $_.Output -notmatch "No action required" })
if ($DriveHealthIssue -eq $true) {
	# Flag error value / mark for remediation
	Write-Output "$((Get-ChildItem -Path $RegistryBase -Recurse | Get-ItemProperty | Where-Object { $_.Output -notmatch "No action required" }).Output)";  exit 1
} else {
	# No issues found
	Write-Output "Disks are in a healthy state. No action required"; exit 0
}

#endregion ScriptRunningCode