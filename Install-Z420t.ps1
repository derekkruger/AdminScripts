<#
Modified from @Sorvani
PrinterName = is the 
$PrinterName = "Name of the Printer"
$PrinterPort = "Printer Port"
$PortHost = "IP address of the printer"
$DriverLocation = "Driver Share"
$DriverName = "Driver Name"
setup the variables to throughout. These will become parameters.#>
$PrinterName = "Zebra GK420t"
$PrinterPort = "10.10.2.143"
$PortHost = "10.10.2.243"
$DriverLocation = "\\host03\drivers\Zebra Technologies\Zebra Setup Utilities\Driver\ZBRN\ZBRN.inf"
$DriverName = "ZDesigner GK420t Plus (ZPL)"


# Import Print Management Module
Import-Module PrintManagement

# Remove any existing printer port
# you will see an error is it does not exist, just ignore
# todo wrap in if statement
# Remove-PrinterPort -name $PrinterPort

# If it doesn't exist
# Add the printer port
$PortExists = Get-Printerport -Name $PrinterPort -ErrorAction SilentlyContinue

if (-not $PortExists) {
Add-PrinterPort -Name $PrinterPort -PrinterHostAddress $PortHost
}

# Add the driver to the driver store
# using this because had failures with -InfPath in Add-PrinterDriver
Invoke-Command {pnputil.exe -a $DriverLocation }

# Add the print driver 
$printDriverExists = Get-PrinterDriver -name $DriverName -ErrorAction SilentlyContinue
if ($printDriverExists) {
 Add-PrinterDriver -name $DriverName

# Add the printer
$PrinterExists = Get-Printer -name $PrinterName -ErrorAction SilentlyContinue

If (-not $PrinterExists) {
Add-Printer -name $PrinterName -PortName $PrinterPort -DriverName $DriverName
} else {
	Write-Warning "PRINTER ALREADY INSTALLED"}
	
}