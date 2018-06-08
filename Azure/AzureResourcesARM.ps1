#AzureResources with ARM / login to a ARM subscription
Login-AzureRmAccount

#list available subscriptions / list currently selected or default
Get-AzureRmSubscription
$azrmsubscriptions = Get-AzureRmSubscription
#gets the subscription for cred dev ARMv6
$azrmsubid = $azrmsubscriptions.Item(5).SubscriptionId;

#select the subscription you want to manage (cred dev in this script)
Select-AzureRmSubscription -SubscriptionId $azrmsubid

#if deploying a template, set context
Set-AzureRmContext -SubscriptionId $azrmsubid

#list available providers (can be listed with location of these -Location)
Get-AzureRmResourceProvider -ListAvailable | Format-Table ProviderNamespace, RegistrationState, ResourceTypes, Locations -AutoSize

#register a service provider with the current account
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.AppService

#create a resource group and storage account
New-AzureRmResourceGroup -Name "AzrHol200Test" -Location "West US"

$azrmgroup = Get-AzureRmResourceGroup -Name "AzrHol200Test"
$azrmgroupname = $azrmgroup.ResourceGroupName
$azrmstoragename = "trmyehol200"
$location = $azrmgroup.Location
New-AzureRmStorageAccount -ResourceGroupName $azrmgroupname -Name $azrmstoragename -Location $location -Type Standard_LRS

#view details get information on your storage account
Get-AzureRmStorageAccount -ResourceGroupName $azrmgroupname -Name $azrmstoragename

#deploy resource group template to resource group
#first, test the template
$templatePath = 'C:\Users\trmye\Documents\Visual Studio 2015\Projects\PHONEREG-DEV-USW\PHONEREG-DEV-USW\Templates\template.json'
$pathToTemplate = 'C:\Users\trmye\Documents\Visual Studio 2015\Projects\PHONEREG-DEV-USW\PHONEREG-DEV-USW\Templates'
Test-AzureRmResourceGroupDeployment -ResourceGroupName $azrmgroupname -TemplateFile $templatePath
6f5479b6-b447-4dc8-9102-76ef50cfec22
AzrHol200Test