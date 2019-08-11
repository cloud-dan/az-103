$email = Read-Host -Prompt 'Input your Azure email address'
$cred = (Get-Credential -UserName $email)
$tenant = Read-Host -Prompt 'Input your Azure tenant'

# Sign in using device code
Connect-AzAccount -Tenant $tenant -SubscriptionName "Visual Studio Enterprise"

# Set Environment variables
$company = "JOk"
$product = "JAM"
$env = "DEV"
$instance = "01"
$region = "EUW"
$location = "westeurope"

