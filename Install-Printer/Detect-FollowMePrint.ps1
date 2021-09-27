#region Printers to install
$printers = @(
    [PSCustomObject]@{
        Printer = "SurreyPrint"
        Server = "Printservice.surrey.ac.uk"
    }
)
#endregion
#region functions
Function Detect-LocalPrinters {
    param (
        [string]$server,

        [string]$printerName
    )
    $printerPath = $null
    $PrinterPath = "\\$($server)\$($printerName)"

    if (Get-Printer -Name "$printerPath" -ErrorAction SilentlyContinue) {
        Write-Host "Printer $printerPath detected" -ForegroundColor Green
    }
    else {
        Write-Host "Printer $printerPath not detected" -ForegroundColor Green
    exit 1
    }

}
#endregion
#region Install printers
foreach ($p in $printers) {
    Detect-LocalPrinters -server $p.Server -printerName $p.Printer
}
#endregion