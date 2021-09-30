$Path = "HKCU:\Software\Adobe\Adobe Acrobat\DC\AVGeneral\"
$Name = "bToggleCustomSaveExperience"
$Type = "DWORD"
$Value = "1"

$Path1 = "HKCU:\Software\Adobe\Adobe Acrobat\DC\AVGeneral\"
$Name1 = "bToggleCustomOpenExperience"
$Type1 = "DWORD"
$Value1 = "1"

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value

Set-ItemProperty -Path $Path1 -Name $Name1 -Type $Type1 -Value $Value1