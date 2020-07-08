# Download most recent CERM.MSI from the server
$url = "http://10.10.1.62/CermBoXX/CERM-CLIENT/cerm.msi"
$output = "C:\scripts\install\CERM\cerm.msi"

Invoke-WebRequest $url -outfile $output
