$email = Read-Host -Prompt 'Input your Azure email address'
$cred = (Get-Credential -UserName $email)
$tenant = Read-Host -Prompt 'Input your Azure tenant'

# Sign in using device code
Connect-AzAccount -Tenant $tenant -SubscriptionName "Visual Studio Enterprise"

# Set Environment variables
$company = "JOK"
$product = "JAM"
$env = "DEV"
$instance = "01"
$region = "EUW"
$location = "westeurope"

# Create resource group
$rgName = "{0}-{1}-{2}-{3}-{4}" -f $company, $product, $env, $instance, $region
Write-Output "Creating Resource Group - $($rgName)"
New-AzResourceGroup -Name $rgName -Location $location

# Create a virtual network
$vnetName = "{0}-VNT" -f $rgName
$addrPrefix = "10.0.0.0/17"
New-AzVirtualNetwork -ResourceGroupName $rgName -Name $vnetName -Location $location -AddressPrefix $addrPrefix

