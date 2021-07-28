<#
  Hivenightmare Remediation Script
  
  Source:  https://thecollective.eu/blog/mitigate-hivenightmare-with-mem/
  Created 24-07-2021
#>

$SystemRestoreEnabledRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
$SystemRestoreEnabledRegKey = "RPSessionInterval"
$SystemRestoreEnabledRegValue = 0
$LocalBuiltInUsersGroupName = (Get-Localgroup -SID S-1-5-32-545).Name

#Execute mitigation
icacls c:\windows\system32\config\*.* /inheritance:e
vssadmin delete shadows /quiet /all

#check permissions
$checkPermissions = icacls C:\windows\system32\config\sam
if ($checkPermissions -like "*$($LocalBuiltInUsersGroupName):(I)(RX*)*") {
    $permissionsSucces = $false
    write-host "ACL change failed. Check permissions running script, e.g. run as SYSTEM."
}
else {
    $permissionsSucces = $true
    Write-Host "Successfully reset permission inheritance on affected files."
}

#check shadow
$checkShadow = Get-WmiObject Win32_ShadowStorage -Property UsedSpace | Select-Object -ExpandProperty UsedSpace
if (0 -eq $checkShadow) {
    $shadowSucces = $true
    Write-Host "Successfully deleted old volume shadow copies."
}
else {
    $shadowSucces = $false
    write-host "Shadow deletion failed. Security software may be blocking this action or check running permissions."
}

 

#check if fixed logic
if ($permissionsSucces -eq $true -and $shadowSucces -eq $true) {
    $fixed = $true
}
else {
    $fixed = $false
}

 

#create new shadow
$ShadowEnabled = $false
if((Get-ItemProperty -Path $SystemRestoreEnabledRegPath -Name $SystemRestoreEnabledRegKey).$SystemRestoreEnabledRegKey -eq 1){
    $ShadowEnabled = $true
}
if ($shadowSucces -eq $true -and $permissionsSucces -eq $true -and $ShadowEnabled -eq $true) {
    wmic shadowcopy call create Volume='C:\'
}

#output data
Write-host "Fixed: $fixed"