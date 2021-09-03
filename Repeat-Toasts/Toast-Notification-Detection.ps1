$Path = "HKLM:\Software\!ProactiveRemediations"
$Name = "20H2NotificationSchTaskCreated"
$Value = 1

$TargetDate = (Get-Date -Day 24 -Month 5 -Year 2021).ToString("ddMMyyy")
$ClientDate = (Get-Date).ToString("ddMMyyy")

If (!($TargetDate -eq $ClientDate)){
    Write-Output "Remediation Target Date""$($TargetDate)"" not valid. Client date is $ClientDate. Remediation will not run."
    Exit 0
}

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Remediation not required."
        Exit 0
    } 
    Write-Output "Remediation required"
    Exit 1
} 
Catch {
    Write-Warning "Error Caught. Remediation will not run."
    Exit 0
}