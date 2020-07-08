New-NetIPAddress -InterfaceAlias "vEthernet (Management)" -IPAddress 10.10.1.5 -PrefixLength 24 -Type Unicast
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (Management)" -ServerAddresses 10.10.1.6
 
New-NetIPAddress -InterfaceAlias "vEthernet (LiveMigration)" -IPAddress 10.10.102.50 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceAlias "vEthernet (Storage01)" -IPAddress 10.1.1.10 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.10.101.50 -PrefixLength 24 -Type Unicast
