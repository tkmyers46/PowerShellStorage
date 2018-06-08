Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName MSFT-ISRM_ISO_IAM_CRED-DEV

Get-AzureRmResourceProvider -ListAvailable | Format-Table -GroupBy ProviderNamespace
    
Register-AzureRmResourceProvider –ProviderNamespace Microsoft.AppService #Register the stuff you need

#Create a resource group
New-AzureRmResourceGroup -Name "sspm-dev2-usw2" -Location "West US" -Tag @{Name="Empty"}, @{Name="ISRM";Value="CredMan"}

#Create a storage account
New-AzureRmStorageAccount -ResourceGroupName "sspm-dev2-usw2" -Name sspmdev2lrsusw2 -Location "West US" -Type Standard_LRS

#Validate storage account creation
Get-AzureRmStorageAccount -ResourceGroupName "sspm-dev2-usw2" -Name sspmdev2lrsusw2