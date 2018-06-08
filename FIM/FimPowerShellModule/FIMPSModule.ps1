<#

.SYNOPSIS

    PowerShell module containing functions to work with the FIMService in FIM 2010 R2 and/or MIM 2016.

    Accepts FIMService URL as Argument.

    Errorhandling within module is very limited. Calling script needs to handle errors.

.EXAMPLE

    Import-Module FIMServiceModule.psm1 -Argumentlist 'http://idmservice.konab.net:5725/ResourceManagementService'

.EXAMPLE

    Import-Module FIMServiceModule.psm1

    Will use default URI http://localhost:5725/ResourceManagementService

#>

 

PARAM([string]$URI = "http://localhost:5725/ResourceManagementService")

if(@(Get-PSSnapin | Where-Object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {Add-PSSnapin FIMAutomation -ErrorAction SilentlyContinue}

 

function CreateObject

{

    <#

    .SYNOPSIS

        Creates a new object of type Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject.

        This object needs to be saved using the SaveObject in order to be commited to the FIMService.

        Supports pipeline input.

    .PARAMETER objectType

        The system name of the FIMService resource type.

    .EXAMPLE

        CreateObject -objectType Person

    .EXAMPLE

        Objects.Type | CreateObject

    #>

 

    PARAM(

         [Parameter(ValueFromPipeline=$true)]

         [string[]]$ObjectType

         )

    BEGIN{}

    PROCESS

    {

       foreach($Type in $ObjectType)

       {

       $NewObject  = New-Object  Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject

       $NewObject.ObjectType = $Type

       $NewObject.SourceObjectIdentifier = [System.Guid]::NewGuid().ToString()

       return  [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$NewObject

       }

    }

    END{} 

}

 

function ImportObject

{

    <#

    .SYNOPSIS

        Converts an $ExportObject of type [Microsoft.ResourceManagement.Automation.ObjectModel.ExportObject] 

        to an $ImportObject of type [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]

        Supports pipeline input.

    #>

    PARAM

        (

        [Parameter(ValueFromPipeline=$true)]

        [Microsoft.ResourceManagement.Automation.ObjectModel.ExportObject[]]$ExportObject

        )

    BEGIN{}

    PROCESS

    {

       foreach($RMObject in $ExportObject.ResourceManagementObject)

       {

       $ImportObject  = New-Object  Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject

       $ImportObject.ObjectType = $RMObject.ObjectType

       $ImportObject.TargetObjectIdentifier = $RMObject.ObjectIdentifier

       $ImportObject.SourceObjectIdentifier = $RMObject.ObjectIdentifier

       $ImportObject.State = 1

       return  [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject

       }

    }

    END{}

}

 

function SetAttribute

{#Only for SingleValue attributes

    PARAM([Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject, [string]$AttributeName, $AttributeValue)

    END

    {

        $ImportChange  = New-Object  Microsoft.ResourceManagement.Automation.ObjectModel.ImportChange

        $ImportChange.Operation = 1

        $ImportChange.AttributeName = $AttributeName

        $ImportChange.AttributeValue = $AttributeValue

        $ImportChange.FullyResolved = 1

        $ImportChange.Locale = "Invariant"

        if ($ImportObject.Changes -eq $null) {$ImportObject.Changes = (,$ImportChange)}

        else {$ImportObject.Changes += $ImportChange}

    }

}

 

function AddMultiValue

{

    PARAM([Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject, [string]$AttributeName, $AttributeValue)

    END

    {

        $ImportChange  = New-Object  Microsoft.ResourceManagement.Automation.ObjectModel.ImportChange

        $ImportChange.Operation = 0

        $ImportChange.AttributeName = $AttributeName

        $ImportChange.AttributeValue = $AttributeValue

        $ImportChange.FullyResolved = 1

        $ImportChange.Locale = "Invariant"

        if ($ImportObject.Changes -eq $null) {$ImportObject.Changes = (,$ImportChange)}

        else {$ImportObject.Changes += $ImportChange}

    }

}

 

function RemoveMultiValue

{

    PARAM([Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject, [string]$AttributeName, $AttributeValue)

    END

    {

        $ImportChange  = New-Object  Microsoft.ResourceManagement.Automation.ObjectModel.ImportChange

        $ImportChange.Operation = 2

        $ImportChange.AttributeName = $AttributeName

        $ImportChange.AttributeValue = $AttributeValue

        $ImportChange.FullyResolved = 1

        $ImportChange.Locale = "Invariant"

        if ($ImportObject.Changes -eq $null) {$ImportObject.Changes = (,$ImportChange)}

        else {$ImportObject.Changes += $ImportChange}

    }

}

 

function SetFilter

{

    <#

    .SYNOPSIS

        Special function to set set the filter attribute in Set or Group. 

        Expects the inner xPath query as input and adds the XML around it before setting the value.

        Does not support pipeline input.

    #>

    PARAM([Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject,[string]$xPath)

    BEGIN{}

    PROCESS

    {

        $FilterXMLBegin  ='<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">'

        $FilterXMLEnd  = '</Filter>'

        $Filter  = $FilterXMLBegin  + $xPath  + $FilterXMLEnd

        SetAttribute  -object $ImportObject  -attributeName Filter  -attributeValue $Filter

    }

    END{}

}

 

function GetReference

{

    <#

    .SYNOPSIS

        Returns the ObjectId (Guid) as string of the returned object. Expects a single object to be found in the query.

        .PARAMETER objectType

           The system name of the FIMService resource type.

        .PARAMETER attributeName

           The system name of the FIMService attribute.

        .PARAMETER attributeValue

           The value in the format expected by the attribute.

    #>

    PARAM([string]$ObjectType,[string]$AttributeName, $AttributeValue)

    END

    {

        $xPath  = "/"+$ObjectType+"["+$AttributeName+"='"+$AttributeValue+"']"

        $ExportObject  = export-fimconfig  -uri $URI -onlyBaseResources -customconfig $xPath

        if($ExportObject)

            {return  $ExportObject.ResourceManagementObject.ObjectIdentifier.Substring(9)}

        else

            {return  $null}

     } 

}

 

function GetObject

{

    <#

        .SYNOPSIS

            Returns object based on single attribute/value match.

            Intended to be used when only single result is expected.

            Does not support pipeline input.

        .PARAMETER objectType

            The system name of the FIMService resource type.

        .PARAMETER attributeName

            The system name of the FIMService attribute.

        .PARAMETER attributeValue

            The value in the format expected by the attribute.

    #>

    PARAM([string]$ObjectType,[string]$AttributeName, $AttributeValue)

    BEGIN

    {}

    PROCESS

    {

        $xPath  = "/"+$ObjectType+"["+$AttributeName+"='"+$AttributeValue+"']"

        $ExportObject  = export-fimconfig  -uri $URI -onlyBaseResources -customconfig $xPath

    }

    END

    {

        return  $ExportObject

    }

}

 

function GetByxPath

{

    <#

    .SYNOPSIS

        Returns array of [Microsoft.ResourceManagement.Automation.ObjectModel.ExportObject] based on xPath query.

        Returns only base resources not dereferenced objects.

        Does not support pipeline input.

    .PARAMETER xPath

        xPath query to use.

        Example: /Person[AccountName='Kent' and extActive=True]

    #>

    PARAM([string]$xPath)

    BEGIN

    {}

    PROCESS

    {

        $ExportObject  = export-fimconfig  -uri $URI -onlyBaseResources -customconfig $xPath

    }

    END

    {

        return  $ExportObject

    }

}

 

function SaveObject

{

    <#

    .SYNOPSIS

        Saves/Updates the object in FIM Service.

        Supports pipelining.

    .PARAM importObject

        The [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject] to commit to FIM Service.

    #>

    PARAM(

        [Parameter(ValueFromPipeline=$true)]

        [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject[]]$ImportObject

    )

    BEGIN{}

    PROCESS

    {

        foreach($Object in $ImportObject)

        {

            $Object  | Import-FIMConfig  -Uri $URI -ErrorAction Stop

        }

    }

    END{}

}

 

function DeleteObject

{

    <#

    .SYNOPSIS

        Delete the object in FIMService.

        Supports pipelining

    .PARAM importObject

        The [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject] to delete in FIM Service.

    #>

    PARAM(

        [Parameter(ValueFromPipeline=$true)]

        [Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject[]]$ImportObject

    )

    BEGIN{}

    PROCESS

    {

        foreach($Object in $ImportObject)

        {

            $Object.State = 2

            $Object  | Import-FIMConfig  -Uri $URI -ErrorAction Stop

        }

    }

    END{}

}
