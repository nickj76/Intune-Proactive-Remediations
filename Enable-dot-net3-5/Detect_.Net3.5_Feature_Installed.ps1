<#
======================================================================================================
 
 Created on:    22.04.2021
 Created by:    Mattias Melkersen
 Version:       0.1  
 Mail:          mm@mindcore.dk
 twitter:       @mmelkersen
 Function:      Detection script if .net 3.5 windows feature has been enabled.
 This script is provided As Is
 Compatible with Windows 10 and later
======================================================================================================
#>

$DotNetState = Get-WindowsOptionalFeature -Online -FeatureName 'NetFx3'

If ($DotNetState.State -eq "Enabled")
    {
        Write-Host "Net 3.5 state Enabled"
        Exit 0
    }
    else
    {
        Write-Host "Net 3.5 state Disabled"
        Exit 1
    }