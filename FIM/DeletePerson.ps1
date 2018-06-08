[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the name of the class to update.")]
    [string] $fimtype,
    [Parameter(Mandatory=$true, HelpMessage="Specify the name of the attribute to update.")]
    [string] $attributeName,    
    $attributeValue,
    $requestor,
    [string] $uri = "http://localhost:5725",
    [switch] $ask)

# load FIM snapin, ignore errors if already loaded
Add-PSSnapin FIMAutomation -ErrorAction SilentlyContinue

# gets the value of a single-valued attribute from an exported object
function GetAttributeValue($exportObject,[string] $name) {
    $attribute = $exportObject.ResourceManagementObject.ResourceManagementAttributes | 
        Where-Object {$_.AttributeName -eq $name}
    if ($attribute -ne $null -and $attribute.Value) {
        $attribute.Value
    }
}

# suppress the progress indicator (makes screen unreadable with many operations)
$ProgressPreference="SilentlyContinue"

# get all objects of specified type
Write-Verbose "Getting $fimtype objects..."
$objects = Export-FIMConfig -uri $uri -CustomConfig "/$fimtype[AccountName='$requestor']" -OnlyBaseResources

# confirmation message
if (${attributeValue} -ne $null) {
    $confirmationMessage = "Deleted ${fimtype} '$requestor'"
} else {
    $confirmationMessage = "Delete failed ${fimtype} ${requestor}"
}

# iterate objects and set attributes
foreach ($object in $objects) {
    $objectID = GetAttributeValue $object "ObjectID"
    $displayName = GetAttributeValue $object "DisplayName"
    $objectType = GetAttributeValue $object "ObjectType"

    # ask for confirmation if specified
    if ($ask -and $(Read-Host "$confirmationMessage '$displayName'? (y/n)") -ne "y") {
        continue
    }
    
    Write-Host "Deleted ${fimtype} '$requestor' '$displayName'"
    
    $importChange = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportChange
    #$importChange.Operation = [Microsoft.ResourceManagement.Automation.ObjectModel.ImportOperation]::Add
    $importChange.Operation = [Microsoft.ResourceManagement.Automation.ObjectModel.ImportOperation]::Delete
    $importChange.AttributeName = ${attributeName}
    if (${attributeValue} -ne $null) {
        $importChange.AttributeValue = ${attributeValue}
    }
    $importChange.FullyResolved = 1
    $importChange.Locale = "Invariant"

    $importObject = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject
    $importObject.ObjectType = $objectType
    $importObject.TargetObjectIdentifier = $objectID
    $importObject.SourceObjectIdentifier = $objectID
    $importObject.State = [Microsoft.ResourceManagement.Automation.ObjectModel.ImportState]::Delete
    $importObject.Changes = (,$importChange)
    
    $importObject | Import-FIMConfig -uri $uri
}


