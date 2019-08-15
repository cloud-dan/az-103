# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-vnet-vnet-rm-ps
Connect-AzAccount

Select-AzSubscription -SubscriptionName "Visual Studio Enterprise"

#####################################
##  Create and configure TestVNet1 ##
#####################################

# Set variables
$RG1 = "TestRG1"
$Location1 = "East US"
$VNetName1 = "TestVNet1"
$FESubName1 = "FrontEnd"
$BESubName1 = "Backend"
$VNetPrefix11 = "10.11.0.0/16"
$VNetPrefix12 = "10.12.0.0/16"
$FESubPrefix1 = "10.11.0.0/24"
$BESubPrefix1 = "10.12.0.0/24"
$GWSubPrefix1 = "10.12.255.0/27"
$GWName1 = "VNet1GW"
$GWIPName1 = "VNet1GWIP"
$GWIPconfName1 = "gwipconf1"
$Connection14 = "VNet1toVNet4"
$Connection15 = "VNet1toVNet5"

# Create a resource group
New-AzResourceGroup -Name $RG1 -Location $Location1

# Create the subnet configurations for TestVNet1
$fesub1 = New-AzVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$besub1 = New-AzVirtualNetworkSubnetConfig -Name $BESubName1 -AddressPrefix $BESubPrefix1
$gwsub1 = New-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GWSubPrefix1

# Create TestVNet1
New-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1 `
    -Location $Location1 -AddressPrefix $VNetPrefix11, $VNetPrefix12 -Subnet $fesub1, $besub1, $gwsub1

# request a pip be allocated to the gateway
$gwpip1 = New-AzPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG1 `
    -Location $Location1 -AllocationMethod Dynamic

# Create the gateway configuration
$vnet1 = Get-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1
$subnet1 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1
$gwipconf1 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 `
    -Subnet $subnet1 -PublicIpAddress $gwpip1

# Create the gateway for TestVNet1
New-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1 `
    -Location $Location1 -IpConfigurations $gwipconf1 -GatewayType Vpn `
    -VpnType RouteBased -GatewaySku VpnGw1

#####################################
##  Create and configure TestVNet4 ##
#####################################

$RG4 = "TestRG4"
$Location4 = "West US"
$VnetName4 = "TestVNet4"
$FESubName4 = "FrontEnd"
$BESubName4 = "Backend"
$VnetPrefix41 = "10.41.0.0/16"
$VnetPrefix42 = "10.42.0.0/16"
$FESubPrefix4 = "10.41.0.0/24"
$BESubPrefix4 = "10.42.0.0/24"
$GWSubPrefix4 = "10.42.255.0/27"
$GWName4 = "VNet4GW"
$GWIPName4 = "VNet4GWIP"
$GWIPconfName4 = "gwipconf4"
$Connection41 = "VNet4toVNet1"

# Create a resource group
New-AzResourceGroup -Name $RG4 -Location $Location4

# Create the subnet configurations for TestVNet4
$fesub4 = New-AzVirtualNetworkSubnetConfig -Name $FESubName4 -AddressPrefix $FESubPrefix4
$besub4 = New-AzVirtualNetworkSubnetConfig -Name $BESubName4 -AddressPrefix $BESubPrefix4
$gwsub4 = New-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GWSubPrefix4

# Create TestVNet4
New-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4 `
-Location $Location4 -AddressPrefix $VnetPrefix41,$VnetPrefix42 -Subnet $fesub4,$besub4,$gwsub4

# Request a public IP address
$gwpip4 = New-AzPublicIpAddress -Name $GWIPName4 -ResourceGroupName $RG4 `
-Location $Location4 -AllocationMethod Dynamic

# Create the gateway configuration
$vnet4 = Get-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4
$subnet4 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet4
$gwipconf4 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName4 -Subnet $subnet4 -PublicIpAddress $gwpip4

# Create the TestVNet4 gateway
New-AzVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $RG4 `
-Location $Location4 -IpConfigurations $gwipconf4 -GatewayType Vpn `
-VpnType RouteBased -GatewaySku VpnGw1