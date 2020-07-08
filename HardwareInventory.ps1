# Before Running the following is required:
# Directory path D:\scripts\inventory must exist or the script needs to be altered to the path of your liking
# LDAP path to the container(s) in AD where the computers you'd like to inventory reside need to be updated in the script
# RPC service has to be running

# Portion of script where it gathers computer names from Active Directory to inventory
cls
Write-Host "Scanning Active Directory for Computer Names....." -ForegroundColor Green
# Place the LDAP path to the container in AD that holds your computers.Script will not work until your info is added.
$1 = [ADSI]"LDAP://OU=Workstations,OU=Computers,OU=DRG,DC=DRE,DC=COM"
foreach ($child in $1.psbase.Children) {
    if ($child.ObjectCategory -like '*computer*') { Echo $child.Name >> d:\scripts\inventory\_$((Get-Date).ToString('MM-dd-yyyy')).txt}
}
# Place the LDAP path to the container in AD that holds your computers.Script will not work until your info is added.
# If you have more than two containers just copy the following and change the $2 to $3.
$2 = [ADSI]"LDAP://OU=Workstations,OU=Computers,OU=DRG,DC=DRE,DC=COM"
foreach ($child in $2.psbase.Children) {
    if ($child.ObjectCategory -like '*computer*') { Echo $child.Name >> D:\scripts\inventory\systemsDT_$((Get-Date).ToString('MM-dd-yyyy')).txt }
}

# Portion of script where gathered computer names are inventoried

If (Test-Path D:\scripts\inventory\systemsDT_$((Get-Date).ToString('MM-dd-yyyy')).txt)
{
 Function RunBody
{
gwmi Win32_ComputerSystem -Comp $entry | Export-CSV D:\scripts\inventory\GeneralHW_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
gwmi Win32_OperatingSystem -Comp $entry | Export-CSV D:\scripts\inventory\OS_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
gwmi Win32_BIOS -Comp $entry | Export-CSV D:\scripts\inventory\BIOS_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
gwmi Win32_Processor -Comp $entry | Export-CSV D:\scripts\inventory\Processor_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
gwmi Win32_LogicalDisk -filter "DriveType = 3" -Comp $entry | Export-CSV D:\scripts\inventory\Disk_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
gwmi Win32_NetworkAdapterConfiguration -Comp $entry |` where{$_.IPEnabled -eq "True"} | Export-CSV D:\scripts\inventory\Nic_DT_$((Get-Date).ToString('MM-dd-yyyy')).csv -append -force -NoTypeInformation
Get-Service remoteregistry -ComputerName $entry | stop-service
}
CLS
  $computers = get-content D:\scripts\inventory\systemsDT_$((Get-Date).ToString('MM-dd-yyyy')).txt
 ForEach ($entry in $computers){
 if (Test-Connection -count 1 -computer $entry -quiet){
 echo $entry >> D:\scripts\inventory\onlineHardwareInvtoryDT_$((Get-Date).ToString('MM-dd-yyyy')).txt
 # "Get-Service remoteregistry -ComputerName $entry | start-service" Starts remote registry. Some systems require this to be turned on to avoid RPC errors.
 # It is turned off after Inventory is complete. If you keep remote registry on all the time please comment out the Stoping of the remote service.
 Get-Service remoteregistry -ComputerName $entry | start-service
 Write-Host "Inventorying system" $entry "....." -ForegroundColor Green
 RunBody $entry}
 Else
 {
 Write-Host "System" $entry "is offline. Updated offline log. " -ForegroundColor Red
 echo $entry >> D:\scripts\inventory\offlineHardwareInvtoryDT_$((Get-Date).ToString('MM-dd-yyyy')).txt
 }
 }
 }
 Else
 {
 CLS
 Write-Host "systemsDT_$((Get-Date).ToString('MM-dd-yyyy')).txt Not found. Data not collected. " -ForegroundColor Red
 }
Write-Host "*************************************************" -ForegroundColor Green
Write-Host "*        The Hardware reports are complete.     *" -ForeGroundColor Green
Write-Host "*                You're Welcome!                *" -ForegroundColor Green
Write-Host "*             Authored by Perry Orr             *" -ForegroundColor Green
Write-Host "*************************************************" -ForegroundColor Green