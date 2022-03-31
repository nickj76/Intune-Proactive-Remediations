Import-Module -Name DellBIOSProvider

$x = "insert password here (use base64 at least to obfuscate the password)"
$z = [System.Text.Encoding]::Ascii.GetString([System.Convert]::FromBase64String($x));

Set-Item -Path DellSmbios:\Security\AdminPassword $z
