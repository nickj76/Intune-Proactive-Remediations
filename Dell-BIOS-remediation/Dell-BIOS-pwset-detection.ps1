$Get_Manufacturer_Info = (Get-WmiObject win32_computersystem).Manufacturer

If($Get_Manufacturer_Info -like "*Dell*")
	{
		$module_name = "DellBIOSProvider"
		If (Get-Module -ListAvailable -Name $module_name)
            {
                Write-Output "Loading Dell module"
                Import-Module $module_name -Force

            } 
		Else
            {
                Install-PackageProvider -Name NuGet -Force

				Write-Output "Installing VC redist for Dell BIOS module"
				Install-Module VcRedist -Force
				Import-Module VcRedist
				New-Item -Path "C:\temp\vcredist" -ItemType directory -Force
				$VcList = Get-VcList -Release 2022 | Get-VcRedist -Path "C:\temp\vcredist"
				$VcList | Install-VcRedist -Silent -Path C:\temp\vcredist

                Write-Output "Installing Dell BIOS module"
                Install-Module -Name $module_name -Force
                Write-Output "Loading Dell module"
                Import-Module $module_name -Force
            }	
		$IsPasswordSet = (Get-Item -Path DellSmbios:\Security\IsAdminPasswordSet).currentvalue 	

	If($IsPasswordSet -eq "true")
		{
			write-output "Your BIOS is password protected"	
			Exit 0
		}
	Else
		{
			write-output "Your BIOS is not password protected"	
			Exit 1
		}
	} 
Else
    {
		write-output "Not a Dell"	
		Exit 0
    }

