company="JOK"
product="JAM"
env="DEV"
instance="01"
region="EUN"
location="northeurope"

# Create resource group name
rgName=$company-$product-$env-$instance-$region
echo $rgName

# login
az login

# Create resource group
az group create --name $rgName --location $location --tags 'env='$env
# Show resource group
az group show -n $rgName

# Create a vnet
vnetName=$rgName-"VNT"
addrPrefix="10.1.0.0/17"
echo $vnetName
az network vnet create --name $vnetName --resource-group $rgName --address-prefixes $addrPrefix

# Get virtual network
az network vnet show --resource-group $rgName --name $vnetName