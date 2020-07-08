# Script to configure networking for the Hyper-V Host

#IP and network parameters
param (
    $TeamName = 'ConvergedNetTeam',
    $SwitchName = 'CNSwitch',
    $DefaultFlowMinimumBandwidthWeight = 20,
    
    $ManagementNetAdapterName = 'Management',
    $ManagementNetAdapterVlan = 10,
    $ManagementNetAdapterIp = '10.10.1.5',
    $ManagementNetAdapterPrefix = 24,
    $ManagementNetAdapterGateway = '10.10.1.1',
    $ManagementNetAdapterDnsServers = '10.10.1.21,10.10.1.22',
    $ManagementNetAdapterWeight = 15,

    $ClusterNetAdapterName = 'Cluster',
    $ClusterNetAdapterVlan = 101,
    $ClusterNetAdapterIp = '10.10.101.50',
    $ClusterNetAdapterPrefix = 24,
    $ClusterNetAdapterWeight = 5,

    $LiveMigrationNetAdapterName = 'LiveMigration',
    $LiveMigrationNetAdapterVlan = 102,
    $LiveMigrationNetAdapterIp = '10.10.102.50',
    $LiveMigrationNetAdapterPrefix = 24,
    $LiveMigrationNetAdapterWeight = 20,

    $Storage01NetAdapterName = 'Storage01',
    $Storage01NetAdapterVlan = 103,
    $Storage01NetAdapterIp = '10.1.1.10',
    $Storage01NetAdapterPrefix = 24,
    $Storage01NetAdapterWeight = 20,

    $Storage02NetAdapterName = 'Storage02',
    $Storage02NetAdapterVlan = 103,
    $Storage02NetAdapterIp = '10.1.1.11',
    $Storage02NetAdapterPrefix = 24,
    $Storage02NetAdapterWeight = 20
    )


#Rename Network Adapters
<# Rename-NetAdapter "OnBoard LAN 1" -NewName "1GBE1"
Rename-NetAdapter "OnBoard LAN 2" -NewName "1GBE2"
Rename-NetAdapter "CPU2 SLOT6 PCI-E 3.0 X16 Port 1" -NewName "10GBE1"
Rename-NetAdapter "CPU2 SLOT6 PCI-E 3.0 X16 Port 2" -NewName "10GBE2" #>

#create converged network switch
# New-VMSwitch -Name $SwitchName -AllowManagementOS $True -NetAdapterName "1GBE1","1GBE2","10GBE2","10GBE2" -EnableEmbeddedTeaming $True

#verify switch and NICs are kosher
Get-VMSwitch -Name $SwitchName | fl NetAdapterInterfaceDescriptions

# Create and configure Management network
Add-VMNetworkAdapter -ManagementOS -Name $ManagementNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $ManagementNetAdapterName -MinimumBandwidthWeight $ManagementNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($ManagementNetAdapterName)" -IPAddress $ManagementNetAdapterIp -PrefixLength $ManagementNetAdapterPrefix -DefaultGateway $ManagementNetAdapterGateway
Set-DnsClientServerAddress -InterfaceAlias "vEthernet ($ManagementNetAdapterName)" -ServerAddresses $ManagementNetAdapterDnsServers
Get-VMNetworkAdapter -ManagementOS $ManagementNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId 0
Get-NetAdapter -Name "vEthernet ($ManagementNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014


# Create and configure STORAGE network
Add-VMNetworkAdapter -ManagementOS -Name $Storage01NetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $Storage01NetAdapterName -MinimumBandwidthWeight $Storage01NetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($Storage01NetAdapterName)" -IPAddress $Storage01NetAdapterIp -PrefixLength $Storage01NetAdapterPrefix -DefaultGateway $Storage01NetAdapterGateway
Set-DnsClientServerAddress -InterfaceAlias "vEthernet ($Storage01NetAdapterName)" -ServerAddresses $Storage01NetAdapterDnsServers
Get-VMNetworkAdapter -ManagementOS $Storage01NetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId 103
Get-NetAdapter -Name "vEthernet ($Storage01NetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

# Create and configure LiveMigration network
Add-VMNetworkAdapter -ManagementOS -Name $LiveMigrationNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $LiveMigrationNetAdapterName -MinimumBandwidthWeight $LiveMigrationNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($LiveMigrationNetAdapterName)" -IPAddress $LiveMigrationNetAdapterIp -PrefixLength $LiveMigrationNetAdapterPrefix -DefaultGateway $LiveMigrationNetAdapterGateway
Set-DnsClientServerAddress -InterfaceAlias "vEthernet ($LiveMigrationNetAdapterName)" -ServerAddresses $LiveMigrationNetAdapterDnsServers
Get-VMNetworkAdapter -ManagementOS $LiveMigrationNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId 102
Get-NetAdapter -Name "vEthernet ($LiveMigrationNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014


# Create and configure Cluster network
Add-VMNetworkAdapter -ManagementOS -Name $ClusterNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $ClusterNetAdapterName -MinimumBandwidthWeight $ClusterNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($ClusterNetAdapterName)" -IPAddress $ClusterNetAdapterIp -PrefixLength $ClusterNetAdapterPrefix -DefaultGateway $ClusterNetAdapterGateway
Set-DnsClientServerAddress -InterfaceAlias "vEthernet ($ClusterNetAdapterName)" -ServerAddresses $ClusterNetAdapterDnsServers
Get-VMNetworkAdapter -ManagementOS $ClusterNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId 101
Get-NetAdapter -Name "vEthernet ($ClusterNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

#Enable RDMA
<# Get-NetAdapterRDMA -Name *Storage* | Enable-NetAdapterRDMA
Get-NetAdapterRDMA -Name *Live-Migration* | Enable-NetAdapterRDMA
 #>

#Set affinity between a vNIC and a physical NIC
 Set-VMNetworkAdapterTeamMapping –VMNetworkAdapterName Storage01 –ManagementOS –PhysicalNetAdapterName 10GBE2 
 #Set-VMNetworkAdapterTeamMapping –VMNetworkAdapterName Storage02 –ManagementOS –PhysicalNetAdapterName  





