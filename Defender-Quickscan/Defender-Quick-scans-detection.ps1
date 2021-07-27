# Configure remediation threshold, e.g. 1 day
# Diduct this value from current datetime
$thresholdDateTime = (Get-Date).AddDays(-1)

# Get defender eventlog entries which indicate successful scan
$mostRecentScan = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" | Where-Object { $_.ID -in @(1001) } | Select-Object -First 1

if ($mostRecentScan.TimeCreated -lt $thresholdDateTime) {
    Write-Warning "No Microsoft Defender Antivirus scan has been completed sine `"$thresholdDateTime`""
    Exit 1
}
else {
    Write-Output "Last Microsoft Defender Antivirus scan completed on `"$([datetime]$mostRecentScan.TimeCreated)`""
    Exit 0
}