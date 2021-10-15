#Define variables
$localAdministrators = @()
$memberCount = 0
$numberLocalAdministrators = 4 #Adjust to your number of administrators

try {
    $currentUser = (Get-CimInstance Win32_ComputerSystem).Username -replace '.*\\'
    $administratorsGroup = ([ADSI]"WinNT://$env:COMPUTERNAME").psbase.children.find("Administrators")
    $administratorsGroupMembers= $administratorsGroup.psbase.invoke("Members")
    foreach ($administrator in $administratorsGroupMembers) { 
        $localAdministrators += $administrator.GetType().InvokeMember('Name','GetProperty',$null,$administrator,$null) 
    }

    if ($localAdministrators.Count -eq $numberLocalAdministrators) {
        foreach($localAdministrator in $localAdministrators) { 
            switch ($localAdministrator) { 
                #Adjust to your local administrators
                "Administrator" { $memberCount = $memberCount + 1; break; } 
                "$currentUser" { $memberCount = $memberCount + 1; break; }
                "[YourGlobalAdminRoleSid]" { $memberCount = $memberCount + 1; break; }
                "[YourDeviceAdminRoleSid]" { $memberCount = $memberCount + 1; break; }
                default { 
                    Write-Host "The found local administrators are no match"
                    exit 1 
                } 
            } 
        }

        if ($memberCount -eq $numberLocalAdministrators) { 
            Write-Host "The found local administrators are a match"
            exit 0 
        }
    }

    else {
        Write-Host "The number of local administrators doesn't match"
        exit 1
    }
}

catch {
    $errorMessage = $_.Exception.Message
    Write-Error $errorMessage
    exit 1
}