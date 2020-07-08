<# 
    Created by: Jason Wasser @wasserja
    Modified: 9/26/2016 11:45:54 AM 
    Version: 1.01
    Changelog: 
     * Fixed wrong variables iSCSI adapters


    Description:
    This script can be used as a template for deploying Hyper-V Converged networking.
    With Windows Server 2012 and above you can combine your 10 GbE (or 1 GbE) NIC's 
    and utilize the bandwidth of all of your network adapters for management, cluster, 
    live migration, and even iSCSI traffic.

    You can further customize the script to add/remove networks. You could add a backup 
    network or remove iSCSI networks. Be sure to adjust the bandwidth weights to total
    100.

    Due to the network changes made in this script it is best to copy this script to the server
    and run it from the server.
#> 
param (
    $TeamName = 'ConvergedNetTeam',
    $SwitchName = 'ConvergedNetSwitch',
    $DefaultFlowMinimumBandwidthWeight = 15,


    <# $ManagementNetAdapterName = 'Management',
    $ManagementNetAdapterVlan = 10,
    $ManagementNetAdapterIp = '10.10.1.7',
    $ManagementNetAdapterPrefix = 24,
    $ManagementNetAdapterGateway = '10.10.1.1',
    $ManagementNetAdapterDnsServers = '10.10.1.21,10.10.1.20',
    $ManagementNetAdapterWeight = 15, #>

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

    $iScsiANetAdapterName = 'iSCSI A',
    $iScsiANetAdapterVlan = 103,
    $iScsiANetAdapterIp = '10.1.1.10',
    $iScsiANetAdapterPrefix = 24,
    $iScsiANetAdapterWeight = 30,

    $iScsiBNetAdapterName = 'iSCSI B',
    $iScsiBNetAdapterVlan = 103,
    $iScsiBNetAdapterIp = '10.1.1.11',
    $iScsiBNetAdapterPrefix = 24,
    $iScsiBNetAdapterWeight = 30
    )

# Change these IP addresses and netmask to parameters.

### Rename Physical Adapters First
# Rename-NetAdapter "LAN 1" -NewName "10GBE1"
#Rename-NetAdapter "OnBoard LAN 1" -NewName "1GBE1"
#Rename-NetAdapter "OnBoard LAN 2" -NewName "1GBE2"
#Rename-NetAdapter "CPU2 SLOT6 PCI-E 3.0 X16 Port 1" -NewName "10GBE1"
#Rename-NetAdapter "CPU2 SLOT6 PCI-E 3.0 X16 Port 2" -NewName "10GBE2"

### Disable Unused NIC Adapters
# Disable-NetAdapter -Name "LAN 4"

# May need to remove any existing switch, and vm network adapters first.

### Delete existing VMNetworkAdapters from the management OS
#Get-VMNetworkAdapter -ManagementOS | Remove-VMNetworkAdapter

### Delete existing VM Switches
#Get-VMSwitch | Remove-VMSwitch

### Remove Existing Team
# Get-NetLbfoTeam | Remove-NetLbfoTeam

### Creating Team from two 10 GbE adapters. The adapter names should be specified as 10GbE1 or whatever name is desired.
# New-NetLBFOTeam –Name $TeamName –TeamMembers "10GBE1","10GBE2" –TeamingMode SwitchIndependent –LoadBalancingAlgorithm Dynamic

############ Create Hyper-V Switches for converged networking using weight based QoS.  ##############

# Creating Hyper-V Switch for Management, cluster, Live migration, iSCSI, and VM converged networks.
# The switch uses weight bandwidth mode for QoS
# Bandwidth weight should total 100
# Management     0
# Cluster         5
# Live Migration 20
# iSCSI A        30
# iSCSI B        30
# Default(VM)    20

# Assuming all networks will go through this team.
New-VMSwitch $SwitchName –NetAdapterName "10GBE1","10GBE2" –AllowManagementOS 0 –MinimumBandwidthMode Weight -Notes "cluster, live migration, iSCSI, and VM networks."

# Set default QoS bucket which will be used by VM traffic
Set-VMSwitch $SwitchName –DefaultFlowMinimumBandwidthWeight 20

######################################################################################################

# Create and configure Management network
<# Add-VMNetworkAdapter -ManagementOS -Name $ManagementNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $ManagementNetAdapterName -MinimumBandwidthWeight $ManagementNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($ManagementNetAdapterName)" -IPAddress $ManagementNetAdapterIp -PrefixLength $ManagementNetAdapterPrefix -DefaultGateway $ManagementNetAdapterGateway
Set-DnsClientServerAddress -InterfaceAlias "vEthernet ($ManagementNetAdapterName)" -ServerAddresses $ManagementNetAdapterDnsServers
Get-VMNetworkAdapter -ManagementOS $ManagementNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId $ManagementNetAdapterVlan
Get-NetAdapter -Name "vEthernet ($ManagementNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014
 #>
 
# Create and configure the Cluster network
Add-VMNetworkAdapter -ManagementOS -Name $ClusterNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $ClusterNetAdapterName -MinimumBandwidthWeight $ClusterNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($ClusterNetAdapterName)" -IPAddress $ClusterNetAdapterIp -PrefixLength $ClusterNetAdapterPrefix
Get-VMNetworkAdapter -ManagementOS $ClusterNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId $ClusterNetAdapterVlan
Get-NetAdapter -Name "vEthernet ($ClusterNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

# Create and configure the Live Migration network
Add-VMNetworkAdapter -ManagementOS -Name $LiveMigrationNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $LiveMigrationNetAdapterName -MinimumBandwidthWeight $LiveMigrationNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($LiveMigrationNetAdapterName)" -IPAddress $LiveMigrationNetAdapterIp -PrefixLength $LiveMigrationNetAdapterPrefix
Get-VMNetworkAdapter -ManagementOS $LiveMigrationNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId $LiveMigrationNetAdapterVlan
Get-NetAdapter -Name "vEthernet ($LiveMigrationNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

# Create and configure iSCSI A network.
Add-VMNetworkAdapter -ManagementOS -Name $iScsiANetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $iScsiANetAdapterName -MinimumBandwidthWeight $iScsiANetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($iScsiANetAdapterName)" -IPAddress $iScsiANetAdapterIp -PrefixLength $iScsiANetAdapterPrefix
Get-VMNetworkAdapter -ManagementOS $iScsiANetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId $iScsiANetAdapterVlan
Get-NetAdapter -Name "vEthernet ($iScsiANetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

# Create and configure the Backup network. 
Add-VMNetworkAdapter -ManagementOS -Name $iScsiBNetAdapterName -SwitchName $SwitchName
Set-VMNetworkAdapter -ManagementOS -Name $iScsiBNetAdapterName -MinimumBandwidthWeight $iScsiBNetAdapterWeight
New-NetIPAddress -InterfaceAlias "vEthernet ($iScsiBNetAdapterName)" -IPAddress $iScsiBNetAdapterIp -PrefixLength $iScsiBNetAdapterPrefix
Get-VMNetworkAdapter -ManagementOS $iScsiBNetAdapterName | Set-VMNetworkAdapterVlan -Access -VlanId $iScsiBNetAdapterVlan
Get-NetAdapter -Name "vEthernet ($iScsiBNetAdapterName)" | Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue 9014

# Verify Bandwidth percentage for the newly created NIC's
Get-VMNetworkAdapter -ManagementOS | Select-Object -Property Name,BandwidthPercentage