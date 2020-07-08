#Add and import AD Posh
Add-WindowsFeature RSAT-AD-Powershell
Import-Module ActiveDirectory

#Host name of Windows Admin Center
$wac = "drgsvr07"

#Get Server Names
$servers = gc \\superfast02\it\scripts\SERVERS2020.TXT

#Get the identity object of WAC
$wacobject = Get-AdComputer -Identity $wac

#set the resource-based kerberos constrained delegation for each node
foreach ($server in $servers)
{
$serverObject = Get-ADComputer -Identity $server
Set-ADComputer -Identity $serverObject -PrincipalsAllowedToDelegateToAccount $wacobject
}
