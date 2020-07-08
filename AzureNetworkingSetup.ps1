Import-module Az

#Remote PowerShell Session To Azure
$AzureCreds = Get-Credential 
Login-AZAccount -Credential $AzureCreds

#Choose Azure Subscription And Then Set It As Selected For This Build This will be the same subscription for all the datacenter build outs.
#$AzureSubscription = Get-AzSubscription | Out-GridView -PassThru
Select-AzSubscription -SubscriptionName "Pay-As-You-Go"

####### Pick The Western Most DataCenter Location You Want For Your Stuff################
$resources = Get-AzResourceProvider -ProviderNamespace Microsoft.Compute
$AZDC1 = $resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations | Out-GridView -Title "Pick the Western Most DataCenter Region" -PassThru

######## Pick The Eastern Most DataCenter Location You Want For Your Stuff###############
$resources = Get-AzResourceProvider -ProviderNamespace Microsoft.Compute
$AZDC2 = $resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations | Out-GridView -Title "Pick the Eastern DataCenter Region You Want to Place The Second 5 Virtual Machines In" -PassThru
########

#### West Data Center Variables #####
$WestResourceGroupName = 'westrg1'

### West DataCenter Subnets##
### West DataCenter Virtual Network Name ##########################
$WestVNetName = "westvnet1"

######### West FrontEnd Global and Local Subnets#############################
$WestFrontEndName = "westfrontend"
$WestSubnetShellFE = "10.50.0.0/16"
$WestFrontEndSubnet = "10.50.0.0/24"

######### West BackEnd Global and Local Subnets##############################
$WestBackEndName = "westbackend"
$WestSubnetShellBE = "10.51.0.0/16"
$WestBackendSubnet = "10.51.0.0/24"

######### West Gateway Subnet################################################
#Has to be GatewaySubnet Don't Change This, Subnet needs to be part of the backend global subnet#
$WestGWSubName = "GatewaySubnet"
$GatewaySubnet = "10.51.255.0/27"
$WestGWName = "westgw"
$WestGWIPName = "westgwip"
$WestGWIPConfigName = "wgwipconf"

################ East DataCenter Subnets##############################################################################################################
######## East DataCenter Virtual Network Name ##########################
#First DataCenter Resource Group Name Needs to Be unique for this datacenter location. This is where you will hold all the storage and virtual networks and virtual servers for this location.
$EastResourceGroupName = 'eastrg1'

#Name the eastside vnet
$EastVNetName = "eastvnet1"

######### East FrontEnd Global and Local Subnets#############################
$EastFrontEndName = "eastfrontend"
$EastSubnetShellFE = "10.60.0.0/16"
$EastFrontEndSubnet = "10.60.0.0/24"

######### East BackEnd Global And Local Subnets##############################
$EastBackEndName = "eastbackend"
$EastSubnetShellBE = "10.61.0.0/16"
$EastBackendSubnet = "10.61.0.0/24"

########### East Gateway Subnet #############################################
#Has to be GatewaySubnet Don't Change This, keep it lowercase, Subnet needs to be part of the backend global subnet#
$EastGWSubName = "GatewaySubnet"
$EastGatewaySubnet = "10.61.255.0/27"
$EastGWName = "eastgw"
$EastGWIPName = "eastgwip"
$EastGWIPConfigName = "egwipconf"

########### Networks Default DNS You can Add / Change This After The Virtual Machines Are Spun Up################################
$DNS = "8.8.4.4"

#################################Cmdlets and switches ##########
#Create the new resource group in the west datacenter
New-AzResourceGroup -Name $WestResourceGroupName -Location $AZDC1
#Create the new resource group in the east datacenter
New-AzResourceGroup -Name $EastResourceGroupName -Location $AZDC2

########## Store the virtual networks subnets name and address prefix in a variable ##########
$WestFESub = New-AzVirtualNetworkSubnetConfig -Name $WestFrontEndName -AddressPrefix $WestFrontEndSubnet
$WestBESub = New-AzVirtualNetworkSubnetConfig -Name $WestBackEndName -AddressPrefix $WestBackendSubnet
$WestGWSub = New-AzVirtualNetworkSubnetConfig -Name $WestGWSubName -AddressPrefix $GatewaySubnet
$EastFESub = New-AzVirtualNetworkSubnetConfig -Name $EastFrontEndName -AddressPrefix $EastFrontEndSubnet
$EastBESub = New-AzVirtualNetworkSubnetConfig -Name $EastBackEndName -AddressPrefix $EastBackendSubnet
$EastGWSub = New-AzVirtualNetworkSubnetConfig -Name $EastGWSubName -AddressPrefix $EastGatewaySubnet

#### Create The Virtual Networks In the Respective DataCenters with the subnets and gateway set.
New-AzVirtualNetwork -Name $WestVNetName -ResourceGroupName $WestResourceGroupName -Location $AZDC1 -AddressPrefix $WestSubnetShellFE,$WestSubnetShellBE -Subnet $WestFESub,$WestBESub,$WestGWSub
New-AzVirtualNetwork -Name $EastVNetName -ResourceGroupName $EastResourceGroupName -Location $AZDC2 -AddressPrefix $EastSubnetShellFE,$EastSubnetShellBE -Subnet $EastFESub,$EastBESub,$EastGWSub

#Now get azure public IP address assigned to your West gateway
$GetWestGWIP = New-AzPublicIpAddress -Name $WestGWSubName -ResourceGroupName $WestResourceGroupName -Location $AZDC1 -AllocationMethod Dynamic
#Now get azure public IP address assigned to your East gateway store it in a variable
$GeteastGWIP = New-AzPublicIpAddress -Name $EastGWSubName -ResourceGroupName $EastResourceGroupName -Location $AZDC2 -AllocationMethod Dynamic

#Store the gateway info in variables so you can create the west gateway
$WestVnet1 = Get-AzVirtualNetwork -Name $WestVNetName -ResourceGroupName $WestResourceGroupName
$WestSubNet = Get-AzVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $WestVnet1
$Westgwip = New-AzVirtualNetworkGatewayIpConfig -Name $WestGWIPConfigName -Subnet $WestSubNet -PublicIpAddress $GetWestGWIP

#Store the gateway info in variables so you can create the east gateway
$EastVnet1 = Get-AzVirtualNetwork -Name $EastVNetName -ResourceGroupName $EastResourceGroupName
$EastSubNet = Get-AzVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $EastVnet1
$Eastgwip = New-AzVirtualNetworkGatewayIpConfig -Name $EastGWIPConfigName -Subnet $EastSubNet -PublicIpAddress $GeteastGWIP

#Commit the gateway settings - THIS CAN TAKE AWHILE, TAKE A BREAK OR SWITCH TO ANOTHER TASK
Write-host -ForegroundColor Green "Commiting West GateWay Settings This Can Take About 30 Min On A Good Day"
New-AzVirtualNetworkGateway -Name $WestGWIPConfigName -ResourceGroupName $WestResourceGroupName -Location $AZDC1 -IpConfigurations $Westgwip -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard

#Commit the gateway settings - THIS CAN TAKE AWHILE, TAKE A BREAK OR SWITCH TO ANOTHER TASK
Write-host -ForegroundColor Green "Commiting East GateWay Settings This Can Take About 30 Min On A Good Day"
New-AzVirtualNetworkGateway -Name $EastGWIPConfigName -ResourceGroupName $EastResourceGroupName -Location $AZDC2 -IpConfigurations $Eastgwip -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard