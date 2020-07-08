# Copy the \scripts directory from \\DRG-MSADMIN01\D$ to the root of C:
# Run this script
# Get a coffee
# Put workstation where it will live

# Install all the things from chocolatey
choco install dotnet3.5, dotnet4.5, adobereader, googlechrome, firefox, crystalreports2010runtime, office365proplus, carbon, bginfo  -yes
Import-Module carbon


# Install CRC and all its stuff
.\c:\scripts\CRC\tools\setup.exe /s /f1"C:\SCRIPTS\CRC\TOOLS\SETUP.ISS"


# CASPOL fix for CRC 
#cd c:\windows\microsoft.net\framework\V2.0.50727
#caspol -pp off -m -ag 1 -url \\CRC_NT\CRCAPPS* FullTrust
#caspol -pp off -m -ag 1 -url file://s:/* FullTrust -name "S Drive"
#CD \SCRIPTS

# Setup ODBC connections for CRC
Add-OdbcDsn -Name "SUPPORT" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=SUPPORT")
Add-OdbcDsn -Name "IMPLIVE" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=IMPLIVE")
Add-OdbcDsn -Name "IMPTEST" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=IMPTEST")
Add-OdbcDsn -Name "LASQL" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=LASQL", "Trusted_Connection=Yes", "Database=IMPLIVE")

# Configure CRC 
regedit /s C:\scripts\CRC115\CRC_TheSystem.reg

# Set Adobe as the default pdf reader
dism /online /Import-DefaultAppAssociations:"C:\Scripts\MyDefaultAppAssociations.xml"


