# New workstation install 
# Version 1.0.0  
# 2/8/18 Derek Kruger
# Run this script
# Get a coffee
# Put workstation where it will live
# Copy the \scripts directory from \\DRG-MSADMIN01\D$ to the root of C:

#Defining Source and Destination path

$DestPath =  "C:\scripts1"
$SourcePath = "\\DRG-MSADMIN01\d$\scripts"

#Create destination on local drive
New-Item -Path $DestPath -ItemType directory

#Copying folder - recurse to get it all...
Copy-Item -Recurse -Path $SourcePath -destination $DestPath

# Enter C:\scripts directory
C:\scripts

# Install Chocolatey
Set-ExecutionPolicy Unrestricted -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv

#Install all sorts of stuff
choco install dotnet3.5, dotnet4.5, teracopy, bginfo, foxitreader, adobereader, googlechrome, firefox, crystalreports2010runtime, office365proplus -yes

# Install CRC 
C:\scripts\CRC115\setup.exe /s /f1"c:\scripts\crc115\setup.iss"

# MSRDO20 copy to syswow64 and register
Copy-Item C:\scripts\CRC115\MSRDO20.DEP C:\Windows\SysWOW64\
Copy-Item C:\scripts\CRC115\MSRDO20.DLL C:\Windows\SysWOW64\
regsvr32 /s /i C:\Windows\SysWOW64\MSRDO20.DLL

# Setup ODBC connections for CRC
Add-OdbcDsn -Name "SUPPORT" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=SUPPORT")
Add-OdbcDsn -Name "IMPLIVE" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=IMPLIVE")
Add-OdbcDsn -Name "IMPTEST" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=CRC_NT", "Trusted_Connection=Yes", "Database=IMPTEST")
Add-OdbcDsn -Name "LASQL" -DriverName "SQL Server" -DsnType "System" -Platform "32-bit" -SetPropertyValue @("Server=LASQL", "Trusted_Connection=Yes", "Database=IMPLIVE")

# Configure CRC 
regedit /s C:\scripts\CRC115\CRC_TheSystem.reg

# EPS Viewer install
C:\scripts\EPSViewer\EPSViewerSetup.exe /verysilent /norestart

# Customer Complaints app install NEED TO FIGURE THIS OUT DOESN'T WORK
# TOO OLD MUST BE RUN MANUALLY SAY YES TO ALL PROMPTS
# \\superfast02\S_Root\VBApps\"Customer Complaints\Install\setup.exe"

# Set Adobe as the default pdf reader
dism /online /Import-DefaultAppAssociations:"C:\Scripts\MyDefaultAppAssociations.xml"

# Set autologin
# .\Set-AutoLogon.ps1 -DefaultUsername "redhawk" -DefaultPassword "redhawk2005"