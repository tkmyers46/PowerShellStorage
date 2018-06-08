#-----------------------------------------------------------------------------
# Sample to get WIP detail. The name of the WIP is ApiTest1.one.microsoft.com
#-----------------------------------------------------------------------------

# Get a specific WIP by name 'wipName'/'networkType'
$resource = "https://atmmt/api/v1.0/gtm/wip/wipName/Corp"

# Get all WIPs that you are owner
$resource = "https://atmmt/api/v1.0/gtm/wip"

#Replace {wipname} place holder with the actual name

$resource= $resource.Replace("wipName", "phoneregistration.gtm.corp.microsoft.com")


# Set the resource, then use RestAPI call to return information about the WIP/WIPs
$wip = Invoke-RestMethod -Method Get -Uri $resource -ContentType "application/json" -UseDefaultCredentials

$wip.PoolDetail