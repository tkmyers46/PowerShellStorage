get-help Get-Credential

$rmSubEnvironment = "AzureCloud"
$rmSubAccount = "trmye@microsoft.com"
$rmSubTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$rmSubId = "6f5479b6-b447-4dc8-9102-76ef50cfec22"
$subscriptionName = "MSFT-ISRM_ISO_IAM_CRED-DEV"

$password = "System2016*!"
$username = "trmye@microsoft.com"
$SecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($domainUsername, $SecurePassword)

$env:USERNAME
$SecurePassword
$Credential
Get-Credential -Credential

Get-Help Login-AzureRmAccount

Login-AzureRmAccount

Get-AzureRmSubscription

$rmSubscriptionObject = Select-AzureRmSubscription -SubscriptionName $subscriptionName

$rmSubscriptionObject = Get-AzureRmSubscription -SubscriptionId $rmSubId

Get-AzureRmSubscription -SubscriptionId $rmSubId

$rmEnvironment = $rmSubscriptionObject.Environment
$rmEnvironment.GetType()

Get-AzureEnvironment