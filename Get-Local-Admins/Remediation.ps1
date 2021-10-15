#Define variables
$currentUser = (Get-CimInstance Win32_ComputerSystem).Username -replace '.*\\'
$localAdministrators = @("[YourGlobalAdminRoleSid]","[YourDeviceAdminRoleSid]") #Adjust to your local administrators

try {
    $administratorsGroup = ([ADSI]"WinNT://$env:COMPUTERNAME").psbase.children.find("Administrators")
    $administratorsGroupMembers = $administratorsGroup.psbase.invoke("Members")
    foreach ($administratorsGroupMember in $administratorsGroupMembers) {
        $administrator = $administratorsGroupMember.GetType().InvokeMember('Name','GetProperty',$null,$administratorsGroupMember,$null) 
        if (($administrator -ne "Administrator") -and ($administrator -ne $currentUser)) {
            $administratorsGroup.Remove("WinNT://$administrator")
            Write-Host "Successfully removed $administrator from Administrators group" 
        }
    }

    foreach ($localAdministrator in $localAdministrators) {
        $administratorsGroup.Add("WinNT://$localAdministrator")
        Write-Host "Successfully added $localAdministrator to Administrators group"
    }

    Write-Host "Successfully remediated the local administrators"
}

catch {
    $errorMessage = $_.Exception.Message
    Write-Error $errorMessage
    exit 1
}