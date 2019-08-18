# Set Environment variables
$company = "JOK"
$product = "JAM"
$env = "DEV"
$instance = "01"
$region = "EUW"
$location = "westeurope"

# Build up resource names
$rgName = "{0}-{1}-{2}-{3}-{4}" -f $company, $product, $env, $instance, $region
$vnetName = "{0}-VNT" -f $rgName

# Get virtual network
$vNet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

# Get subnet
$subnet = Get-AzVirtualNetworkSubnetConfig -Name "app-subnet" -VirtualNetwork $vNet

# Create puplic IP
$pipName = "{0}-PIP" -f $rgName
$publicIP = New-AzPublicIpAddress `
    -Name $pipName `
    -ResourceGroupName $rgName `
    -AllocationMethod Dynamic `
    -Location $location

# Create internal IP config
$IPConfig = New-AzNetworkInterfaceIpConfig  `
    -Name PrivateIp `
    -Subnet $subnet `
    -PrivateIpAddress 10.0.0.4 `
    -PublicIpAddress $publicIP `
    -Primary

# Create NIC
$NICName = "{0}{1}{2}{3}{4}-NIC" -f $company, $product, $env, $instance, $region
$NIC = New-AzNetworkInterface `
    -Name $NICName.ToLower() `
    -ResourceGroupName $rgName `
    -Location $location `
    -IpConfiguration $IPConfig
