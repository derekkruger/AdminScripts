#copy setup bits to local machine
$install_path = "C:\SCRIPTS\INSTALL\CERM"
If(!(test-path $install_path))
{
      New-Item -ItemType Directory -Force -Path $install_path
}

# Download most recent CERM.MSI from the server
$url = "http://10.10.1.62/CermBoXX/CERM-CLIENT/cerm.msi"
$output = "C:\scripts\install\CERM\cerm.msi"

Invoke-WebRequest $url -outfile $output

msiexec /i C:\scripts\install\cerm\cerm_drg.msi /passive /qb /norestart /log C:\scripts\install\CERM\cerminstall.log
$path = "C:\ProgramData\Cerm\Database"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
Copy-Item C:\scripts\INSTALL\CERM\CermConnectionDefs.ini C:\ProgramData\cerm\Database\

# ADD CERM SERVERS TO HOSTS FILE
$file = "$env:windir\System32\drivers\etc\hosts"
"10.10.1.60 CERM-ENGINE" | Add-Content -PassThru $file
"10.10.1.61 CERM-DATA" | Add-Content -PassThru $file