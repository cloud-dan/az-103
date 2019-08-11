company = "JOK"
product = "JAM"
env = "DEV"
instance = "01"
region = "EUW"
location = "westeurope"

# login
az login
# Show tags on resource group
az group show -n $rgName --query tags

# Create a vnet
az network vnet create