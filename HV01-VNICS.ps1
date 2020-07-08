 Add-VMNetworkAdapter -ManagementOS -Name "Management" -SwitchName "VMNET"
Add-VMNetworkAdapter -ManagementOS -Name "LiveMigration" -SwitchName "VMNET"
Add-VMNetworkAdapter -ManagementOS -Name "CSV" -SwitchName "VMNET"

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Management" -Access -VlanId 10
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "CSV" -Access -VlanId 100
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "LiveMigration" -Access -VlanId 101

Set-VMNetworkAdapter -ManagementOS -Name "LiveMigration" -MinimumBandwidthWeight 20
Set-VMNetworkAdapter -ManagementOS -Name "CSV" -MinimumBandwidthWeight 10
Set-VMNetworkAdapter -ManagementOS -Name "Management" -MinimumBandwidthWeight 10




# Set IP Address Management
New-NetIPAddress -InterfaceAlias "vEthernet (Management)" -IPAddress 192.168.25.11 -PrefixLength "24" -DefaultGateway 192.168.25.1
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (Management)" -ServerAddresses 192.168.25.51, 192.168.25.52

# Set LM and CSV
New-NetIPAddress -InterfaceAlias "vEthernet (LiveMigration)" -IPAddress 192.168.31.11 -PrefixLength "24"
New-NetIPAddress -InterfaceAlias "vEthernet (CSV)" -IPAddress 192.168.32.11 -PrefixLength "24"

# iSCSI
New-NetIPAddress -InterfaceAlias "iSCSI01" -IPAddress 192.168.71.11 -PrefixLength "24"
New-NetIPAddress -InterfaceAlias "iSCSI02" -IPAddress 192.168.72.11 -PrefixLength "24" 