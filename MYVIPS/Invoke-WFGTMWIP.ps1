workflow Invoke-WFGTMWIP
{
	param
    (       
        [Parameter(Mandatory=$false)]
        [string]$LoggedInUserName,

        [Parameter(Mandatory=$false)]
        [string]$PoolName,                               
             
        [Parameter(Mandatory=$false)]
        [string]$OwnerSGName,

		[Parameter(Mandatory=$false)]
        [string]$Body = "",
		
        [Parameter(Mandatory=$false)]
        [string]$WipName,

        [Parameter(Mandatory=$false)]
        [string]$VipName,
                    
        [Parameter(Mandatory=$false)]
        [string]$NetworkType,
		        
		[Parameter(Mandatory=$false)]
        [string]$Activity,

        [Parameter(Mandatory=$false)]
        [string]$ValidationOnly
    )

    #region STATIC_VARIABLES
    #------------------------------
    # Declaring All Static Variables Here
    #------------------------------
	
    #DEV - azcusimetmct01
    #UAT - atmmtuat
    #Prod - atmmt
    [string]$BASE_URI = "https://atmmt/api/v1.0"    
    [string]$RUNBOOK_NAME    = 'Invoke-WFGTMVIP' # Name of the current runbook.
    [string]$RUNBOOK_WORKER  = "$ENV:ComputerName"   # Runbook Worker Name
    [hashtable]$SUPPORTED_ACTIVITY_VALUES  = @{
         "SAGETWIPS" = "GET"
         "SAGTMDATACENTER"	= "GET"         
         "CREATEOWNERSG" = "POST"
         "DELETEOWNERSG" = "DELETE"
         "CREATEWIP"	= "POST"
         "UPDATEWIP"	= "PUT"
         "DELETEWIP"	= "DELETE"
         "GETWIP"	    = "GET"
         "GETALLWIPS"	= "GET"
         "UPDATEPOOL"	= "PUT"
         "CREATEPOOLMEMBER"	= "POST"
         "DELETEPOOLMEMBER"	= "DELETE"
         "UPDATEPOOLMEMBER"	= "PUT"                  
 		} # Hashtable of Activity values and their API Verbs
		
	#------------------------------
    #endregion
	
	#region Runtime Variables
    #------------------------------
    # Declaring All Runtime ( Dynamic ) Variables Here
    #------------------------------

    [bool]$ShouldContinue = $true                         # This variable should be updated as the runbook progresses
	[bool]$Success        = $false                        # This variable should only be manipulated ONCE at the very end of the workflow, based on the final value of $ShouldContinue
    [string]$SmaJobId     = $PSPrivateMetadata.Jobid.Guid #http://technet.microsoft.com/en-us/library/jj129719.aspx
    [string]$ErrorData    = $null                         # This variable should be used to capture any error messages alone the way...
	[string]$TargetVerb   = $null                         # This variable holds the Verb which we in API functions.
	[string]$TargetURI    = $null                         # This variable holds the URI which we in API functions
	
    #------------------------------
    #endregion
	
	#region Input Validations
	#------------------------------
    # We will do all Input Validations Here
    #------------------------------

	# Converting Activity to Upper Case for case identity
    $Activity = InlineScript {  $Activity = $Using:Activity ; $Activity.toUpper(); }

	# Activity Validation
    if($Activity -notin $SUPPORTED_ACTIVITY_VALUES.Keys)
    {
        $ShouldContinue = $false
        $ErrorData += "[E] - The input value for the Activity is not supported."
    }
	
	# Other Validations
	if($ShouldContinue)
	{                
        #SuperAdmin
        if( ($Activity -eq "SAGETWIPS") -and ($NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Super Admin Get Wips activity, NetworkType is required."
		}

        #GTMPool
        if( ($Activity -eq "UPDATEPOOL") -and ($Body -eq $null -or $Body -eq "" -or $WipName -eq $null -or $PoolName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Pool activity, Body, Wip Name, PoolName, NetworkType are required."
		}
        
        #GTMPoolMember
        if( ($Activity -eq "CREATEPOOLMEMBER") -and ($Body -eq $null -or $Body -eq "" -or $WipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Create Pool Member activity, Body, Wip Name, NetworkType are required."
		}
        if( ($Activity -eq "UPDATEPOOLMEMBER") -and ($Body -eq $null -or $Body -eq "" -or $WipName -eq $null -or $VipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Pool Member activity, Body, Wip Name, Vip Name, NetworkType are required."
		}
        if( ($Activity -eq "DELETEPOOLMEMBER") -and ($WipName -eq $null -or $VipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Delete Pool Member activity, Wip Name, Vip Name, NetworkType are required."
		}        

        #GTMVipOwner
        if( ($Activity -eq "CREATEOWNERSG") -and ($Body -eq $null -or $Body -eq "" -or $WipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Create Owner Security Group activity, Body, WipName, NetworkType are required."
		}
        if( ($Activity -eq "DELETEOWNERSG") -and ($WipName -eq $null -or $OwnerSGName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Delete Owner Security Group activity, WipName, OwnerSGName, NetworkType are required."
		}

        #GTMWip
		if( ($Activity -eq "CREATEWIP") -and ($Body -eq $null -or $Body -eq "" -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Create Wip activity, Body, NetworkType are required."
		}		
		if( ($Activity -eq "DELETEWIP") -and ($WipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Delete Wip Activity, Wip Name, NetworkType are required."
		}
        if( ($Activity -eq "UPDATEWIP") -and ($Body -eq $null -or $Body -eq "" -or $WipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Wip Activity, Body, Wip Name, NetworkType are required."
		}
        if( ($Activity -eq "GETWIP") -and ($WipName -eq $null -or $NetworkType -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Get Wip Activity, WIP Name, NetworkType are required."
		}         
	}
	
	#endregion
	
	#region Gathering Inputs
	#------------------------------
    # We will try set all input Variables Here
    #------------------------------

	if($ShouldContinue)
	{
		# Verb to be used in API Calls - Post/Get/Delete
		$TargetVerb = $SUPPORTED_ACTIVITY_VALUES[$Activity]
		
		# URI to be used in API calls
        if($Activity -eq "SAGTMDATACENTER")
        {
            $TargetURI = $BASE_URI+"/superadmin/gtmdevice"
            $Body = $null
        }
        elseif($Activity -eq "SAGETWIPS")
		{
			$TargetURI = $BASE_URI+"/superadmin/wip/{0}" -f $NetworkType
            $Body = $null
		}       
        elseif($Activity -eq "UPDATEPOOL")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/pool/{1}/{2}" -f $WipName,$PoolName,$NetworkType
		}        
        elseif($Activity -eq "CREATEPOOLMEMBER")
		{			
            if($ValidationOnly -eq 'true' -or $ValidationOnly -eq 'false')
            {
			    $TargetURI = $BASE_URI+"/gtm/wip/{0}/members/{1}?ValidationOnly={2}" -f $WipName,$NetworkType,$ValidationOnly 
            }else
            {
                $TargetURI = $BASE_URI+"/gtm/wip/{0}/members/{1}" -f $WipName,$NetworkType
            }
		}
        elseif($Activity -eq "UPDATEPOOLMEMBER")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/members/{1}/{2}" -f $WipName,$VipName,$NetworkType
		}
        elseif($Activity -eq "DELETEPOOLMEMBER")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/members/{1}/{2}" -f $WipName,$VipName,$NetworkType
            $Body = $null
		}        
        elseif($Activity -eq "CREATEOWNERSG")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/owner/{1}" -f $WipName,$NetworkType
		}
        elseif($Activity -eq "DELETEOWNERSG")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/owner/{1}/{2}" -f $WipName,$OwnerSGName,$NetworkType
            $Body = $null
		}
		elseif($Activity -eq "CREATEWIP")
		{
            if($ValidationOnly -eq 'true' -or $ValidationOnly -eq 'false')
            {
			   $TargetURI = $BASE_URI+"/gtm/wip/{0}?ValidationOnly={1}" -f $NetworkType,$ValidationOnly   
            }else
            {
                $TargetURI = $BASE_URI+"/gtm/wip/{0}" -f $NetworkType
            }
		}
		elseif($Activity -eq "DELETEWIP")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/{1}" -f $WipName,$NetworkType
            $Body = $null		
		}
        elseif($Activity -eq "UPDATEWIP")
		{
			$TargetURI = $BASE_URI+"/gtm/Wip/{0}/{1}" -f $WipName,$NetworkType			
		}
        elseif($Activity -eq "GETWIP")
		{
			$TargetURI = $BASE_URI+"/gtm/wip/{0}/{1}" -f $WipName,$NetworkType
            $Body = $null		
		}
        elseif($Activity -eq "GETALLWIPS")
		{
			$TargetURI = $BASE_URI+"/gtm/wip"
            $Body = $null
		}        
	}
	#endregion
	
	#region Pre-Defined Functions
	#------------------------------
    # Declaring All Pre-Defined Functions Here
    #------------------------------

	function CallAPI()
	{            
	    param
	    (
	        [Parameter(Mandatory=$true)]
	        [string] $uri, 

	        [Parameter(Mandatory=$false)]
	        [string] $body, 

            [Parameter(Mandatory=$false)]
	        [string] $userName,

	        [Parameter(Mandatory=$true)]
	        [string] $verb
	    )
		
		$Result = $false
		$Message = ""
		    
		try 
		{
            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

            if($userName -ne $null -and $userName -ne "")
            {
                $headers.Add("X-TM-LoggedInUserName", $userName)
            }


            #Send body only when its not null or empty
            if($Body -eq "" -or $Body -eq $null)
            {
                $response = Invoke-WebRequest -Uri $uri -UseDefaultCredentials -Method:$verb -ContentType "application/json" -Headers $headers -TimeoutSec 180 -ErrorAction:Stop
            }
            else
            {
    		    $response = Invoke-WebRequest -Uri $uri -UseDefaultCredentials -Method:$verb -Body:$body -ContentType "application/json" -Headers $headers -TimeoutSec 180 -ErrorAction:Stop
            }

			
			if($response -eq $null)
			{
				$response = "[E] : Request Failed - No response from the API. "
			}
			else
			{
				#success status code
	    		$statuscode = $response.StatusCode                           

                Write-Output "StatusCode: $statuscode"                
                Write-Output $response.Content | ConvertFrom-Json | Format-List
			}
		} 
		catch 
		{
			$ErrorMessage = $_			
            $Message = "[E] : Request Failed - $ErrorMessage "

            Write-Output $Message
		}
		
	}
	#endregion
	
    #region Implementation
	#------------------------------
    # We will call ATM VIP API here
    #------------------------------

    if($ShouldContinue)
    {
		Write-Output "Calling ATM VIP API with parameters: "
		Write-Output "Verb : $TargetVerb ; $Body"
		Write-Output "URI  : $TargetURI "
        #Write-Output "LoggedInUserName  : $LoggedInUserName "

        try
		{            
			#call ATM API    		
            CallAPI -uri $TargetURI -body $Body -userName $LoggedInUserName -verb $TargetVerb			
		}
		catch
        {   
            # Catch the Exception thrown in Try block and remove extra line breaks, single quotes or double quotes to make it readable.
            $ErrorMessage = $_
            $ShouldContinue = $false
            $ErrorData += "[E] : Request Failed - $ErrorMessage "
        }        
    }

    # Write validation and exception output
    Write-Output $ErrorData

    #endregion	
}
