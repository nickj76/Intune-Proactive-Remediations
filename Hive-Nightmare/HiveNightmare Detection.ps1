<#
  Hivenightmare Detection Script
  
  Source:  https://thecollective.eu/blog/mitigate-hivenightmare-with-mem/
  Created 24-07-2021
#>



$LocalBuiltInUsersGroupName = (Get-Localgroup -SID S-1-5-32-545).Name

$checkPermissions = icacls c:\Windows\System32\config\sam
if ($checkPermissions -like "*$($LocalBuiltInUsersGroupName):(I)(RX*)*") {
    Write-Host "Computer is vulnerable"
    Exit 1
}
else {
    Write-Host "Computer is not vulnerable"
    Exit 0
}