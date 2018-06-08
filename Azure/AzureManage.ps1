#log in
Add-AzureAccount

#list available subscriptions / list currently selected or default
Get-AzureSubscription
Get-AzureSubscription -Current
Get-AzureSubscription -Default

#select the subscription you want to manage
$vsenterprise = "Visual Studio Enterprise with MSDN"
Select-AzureSubscription -SubscriptionName $vsenterprise

#Publish settings file
Get-AzurePublishSettingsFile

#import the publish settings file to current powershell session
Import-AzurePublishSettingsFile -PublishSettingsFile C:\vsentpsp.publishsettings

#get a list of subscriptions by name
Get-AzureSubscription | Select SubscriptionName

#get a list of azure locations including machine templates and sizes / list them by name
Get-AzureLocation
Get-AzureLocation | Select DisplayName
$azlocations = Get-AzureLocation | Select DisplayName
$southcentralus = $azlocations.Item(1).DisplayName;

#create affinity group and set one of the locations
New-AzureAffinityGroup -Name pslab-affinitygroup -Location $southcentralus

#create an azure storage account associated with the location and subscription
New-AzureStorageAccount -StorageAccountName vsentpslab -AffinityGroup pslab-affinitygroup

#take a look at the current subscription defaults (no storage account name yet) / set storage
Get-AzureSubscription
Set-AzureSubscription -SubscriptionName $vsenterprise -CurrentStorageAccountName vsentpslab

#list available vm images that match the label of win2012 datacenter / create variable
Get-AzureVMImage -Verbose:$false | Where-Object{$_.Label -like "Windows Server 2012 Datacenter*"} | Format-Table Label, PublishedDate -AutoSize
$vmimagelist = Get-AzureVMImage -Verbose:$false | Where-Object{$_.Label -like "Windows Server 2012 Datacenter*"} | Format-Table Label, PublishedDate -AutoSize

#assign the 2015 win2012 datacenter image (name of VHD image for this OS)
$vmimage = @(Get-AzureVMImage | Where-Object -Property Label -Match "Windows Server 2012 Datacenter, December 2015").ImageName

#set necessary variables/properties for new vm
$vmname = "pslabvmtrmye"
$myadminname = "tkmyers46"
$myadminpwd = "!!**5439mK"

#create vm with image, os type, vmname, servicename, admin creds, and group
#if this fails, try renaming the $vmname variable
New-AzureQuickVM -ImageName $vmimage -Windows -Name $vmname -ServiceName $vmname -AdminUsername $myadminname -Password $myadminpwd -AffinityGroup pslab-affinitygroup

#get a list of current vms in the subscription
Get-AzureVM