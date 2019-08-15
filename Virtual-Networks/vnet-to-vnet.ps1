# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-vnet-vnet-rm-ps
Connect-AzAccount

Select-AzSubscription -SubscriptionName "Visual Studio Enterprise"

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