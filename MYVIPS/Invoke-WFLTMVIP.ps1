workflow Invoke-WFLTMVIP
{
	param
    (       
        [Parameter(Mandatory=$false)]
        [string]$LoggedInUserName,

        [Parameter(Mandatory=$false)]
        [string]$PoolName,

        [Parameter(Mandatory=$false)]
        [string]$NodeName,

        [Parameter(Mandatory=$false)]
        [string]$MemberName,        
             
        [Parameter(Mandatory=$false)]
        [string]$OwnerSGName,

		[Parameter(Mandatory=$false)]
        [string]$Body = "",
		
        [Parameter(Mandatory=$false)]
        [string]$VipName,

        [Parameter(Mandatory=$false)]
        [string]$Area,
    
        [Parameter(Mandatory=$false)]
        [string]$NetworkType,

        [Parameter(Mandatory=$false)]
        [string]$DataCenter,
		        
		[Parameter(Mandatory=$false)]
        [string]$Activity,

        [Parameter(Mandatory=$false)]
        [string]$ValidationOnly,

        [Parameter(Mandatory=$false)]
        [string]$FQDN,
		
		[Parameter(Mandatory=$false)]
        [string]$CNAME
    )

    #region STATIC_VARIABLES
    #------------------------------
    # Declaring All Static Variables Here
    #------------------------------
	
    #DEV - azcusimetmct01
    #UAT - atmmtuat
    #Prod - atmmt
    [string]$BASE_URI = "https://atmmt/api/v1.0"    
    [string]$RUNBOOK_NAME    = 'Invoke-WFLTMVIP' # Name of the current runbook.
    [string]$RUNBOOK_WORKER  = "$ENV:ComputerName"   # Runbook Worker Name
    [hashtable]$SUPPORTED_ACTIVITY_VALUES  = @{
         "LTMDATACENTER"	= "GET"
         "SAGETALLVIPS" = "GET"
         "SAGETALLDEVICE" = "GET"
         "UPDATEPOOL"	= "PUT"
         "UPDATENODE"	= "PUT"
         "CREATEPOOLMEMBER"	= "POST"
         "UPDATEPOOLMEMBER"	= "PUT"
         "DELETEPOOLMEMBER"	= "DELETE"
         "GETALLMONITORS" = "GET"
         "CREATEOWNERSG" = "POST"
         "DELETEOWNERSG" = "DELETE"
         "CREATEVIP"	= "POST"
		 "DELETEVIP"	= "DELETE"
		 "UPDATEVIP"	= "PUT"
		 "GETVIP"	    = "GET"
         "GETALLVIPS"	= "GET"
         "CREATEDNS"	= "POST"
         "DELETEDNS"	= "DELETE" 
		 "CREATECNAME"	= "POST"
         "DELETECNAME"	= "DELETE"
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
        if( ($Activity -eq "SAGETALLVIPS") -and ($Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Super Admin Get All Vips activity, Area, NetworkType, DataCenter are required."
		}

        #LTMPool
        if( ($Activity -eq "UPDATEPOOL") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $PoolName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Pool activity, Body, VIPName, PoolName, Area, NetworkType, DataCenter are required."
		}

        #LTMNode
        if( ($Activity -eq "UPDATENODE") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $NodeName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Node activity, Body, VIPName, NodeName, Area, NetworkType, DataCenter are required."
		}

        #LTMPoolMember
        if( ($Activity -eq "CREATEPOOLMEMBER") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $PoolName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Create Pool Member activity, Body, VIPName, PoolName, Area, NetworkType, DataCenter are required."
		}
        if( ($Activity -eq "UPDATEPOOLMEMBER") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $PoolName -eq $null -or $MemberName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Pool Member activity, Body, VIPName, PoolName, MemberName, Area, NetworkType, DataCenter are required."
		}
        if( ($Activity -eq "DELETEPOOLMEMBER") -and ($VipName -eq $null -or $PoolName -eq $null -or $MemberName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Delete Pool Member activity, VIPName, PoolName, MemberName, Area, NetworkType, DataCenter are required."
		}

        #LTMMonitor
        if( ($Activity -eq "GETALLMONITORS") -and ($Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Get all Monitors activity, Area, NetworkType, DataCenter are required."
		}

        #LTMVipOwner
        if( ($Activity -eq "CREATEOWNERSG") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Create Owner Security Group activity, Body, VipName, Area, NetworkType, DataCenter are required."
		}
        if( ($Activity -eq "DELETEOWNERSG") -and ($VipName -eq $null -or $OwnerSGName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Delete Owner Security Group activity, VIP Name, OwnerSGName, Area, NetworkType, DataCenter are required."
		}

        #LTMVip
		if( ($Activity -eq "CREATEVIP") -and ($Body -eq $null -or $Body -eq "" -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Create Activity, Body, Area, NetworkType, DataCenter are required."
		}		
		if( ($Activity -eq "DELETEVIP") -and ($VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Delete Activity, VIP Name, Area, NetworkType, DataCenter are required."
		}
        if( ($Activity -eq "UPDATEVIP") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Update Activity, Body, VIP Name, Area, NetworkType, DataCenter are required."
		}
        if( ($Activity -eq "GETVIP") -and ($VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null) )
		{
			$ShouldContinue = $false
        	$ErrorData += "[E] - For Get Vip Activity, VIP Name, Area, NetworkType, DataCenter are required."
		} 
        #DNS
        if(($Activity -eq "CREATEDNS") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null))
        {
            $ShouldContinue = $false
        	$ErrorData += "[E] - For Create DNS Activity, Body, VIP Name, Area, NetworkType, DataCenter are required."
        }    
        if(($Activity -eq "DELETEDNS") -and ($VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null))
        {
            $ShouldContinue = $false
        	$ErrorData += "[E] - For Delete DNS Activity, VIP Name, Area, NetworkType, DataCenter are required."
        }  
		#CNAME
        if(($Activity -eq "CREATECNAME") -and ($Body -eq $null -or $Body -eq "" -or $VipName -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null))
        {
            $ShouldContinue = $false
        	$ErrorData += "[E] - For Create CNAME Activity, Body, VIP Name, Area, NetworkType, DataCenter are required."
        }    
        if(($Activity -eq "DELETECNAME") -and ($VipName -eq $null -or $CNAME -eq $null -or $Area -eq $null -or $NetworkType -eq $null -or $DataCenter -eq $null))
        {
            $ShouldContinue = $false
        	$ErrorData += "[E] - For Delete CNAME Activity, CNAME, VIP Name, Area, NetworkType, DataCenter are required."
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
        if($Activity -eq "LTMDATACENTER")
        {
            $TargetURI = $BASE_URI+"/ltm/datacenter"
            $Body = $null
        }
        elseif($Activity -eq "SAGETALLVIPS")
		{
			$TargetURI = $BASE_URI+"/superadmin/vip/{0}/{1}/{2}" -f $Area,$NetworkType,$DataCenter
            $Body = $null
		}
        elseif($Activity -eq "SAGETALLDEVICE")
		{
			$TargetURI = $BASE_URI+"/superadmin/ltmdevice"
            $Body = $null
		}
        elseif($Activity -eq "UPDATEPOOL")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/pool/{1}/{2}/{3}/{4}" -f $VipName,$PoolName,$Area,$NetworkType,$DataCenter
		}
        elseif($Activity -eq "UPDATENODE")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/node/{1}/{2}/{3}/{4}" -f $VipName, $NodeName,$Area,$NetworkType,$DataCenter
		}
        elseif($Activity -eq "CREATEPOOLMEMBER")
		{
		   if($ValidationOnly -eq 'true' -or $ValidationOnly -eq 'false')
            {
			   $TargetURI = $BASE_URI+"/ltm/vip/{0}/pool/{1}/members/{2}/{3}/{4}?ValidationOnly={5}" -f $VipName,$PoolName,$Area,$NetworkType,$DataCenter,$ValidationOnly  
            }
            else
            {
			    $TargetURI = $BASE_URI+"/ltm/vip/{0}/pool/{1}/members/{2}/{3}/{4}" -f $VipName,$PoolName,$Area,$NetworkType,$DataCenter
            }
		}
        elseif($Activity -eq "UPDATEPOOLMEMBER")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/pool/{1}/members/{2}/{3}/{4}/{5}" -f $VipName,$PoolName,$MemberName,$Area,$NetworkType,$DataCenter
		}
        elseif($Activity -eq "DELETEPOOLMEMBER")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/pool/{1}/members/{2}/{3}/{4}/{5}" -f $VipName,$PoolName,$MemberName,$Area,$NetworkType,$DataCenter
            $Body = $null
		}
        elseif($Activity -eq "GETALLMONITORS")
		{
			$TargetURI = $BASE_URI+"/ltm/monitor/{0}/{1}/{2}" -f $Area,$NetworkType,$DataCenter
            $Body = $null
		}
        elseif($Activity -eq "CREATEOWNERSG")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/owner/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter
		}
        elseif($Activity -eq "DELETEOWNERSG")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/owner/{1}/{2}/{3}/{4}" -f $VipName,$OwnerSGName,$Area,$NetworkType,$DataCenter
            $Body = $null
		}
		elseif($Activity -eq "CREATEVIP")
		{
            if($ValidationOnly -eq 'true' -or $ValidationOnly -eq 'false')
            {
			   $TargetURI = $BASE_URI+"/ltm/vip/{0}/{1}/{2}?ValidationOnly={3}" -f $Area,$NetworkType,$DataCenter,$ValidationOnly   
            }else
            {
                $TargetURI = $BASE_URI+"/ltm/vip/{0}/{1}/{2}" -f $Area,$NetworkType,$DataCenter
            }
		}
		elseif($Activity -eq "DELETEVIP")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter	
            $Body = $null		
		}
        elseif($Activity -eq "UPDATEVIP")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter			
		}
        elseif($Activity -eq "GETVIP")
		{
			$TargetURI = $BASE_URI+"/ltm/vip/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter
            $Body = $null		
		}
        elseif($Activity -eq "GETALLVIPS")
		{
			$TargetURI = $BASE_URI+"/ltm/vip"
            $Body = $null
		}
        elseif($Activity -eq "CREATEDNS")
		{
			$TargetURI = $BASE_URI+"/dns/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter            
		} 
        elseif($Activity -eq "DELETEDNS")
		{
			$TargetURI = $BASE_URI+"/dns/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter
            $Body = $null
		}
		elseif($Activity -eq "CREATECNAME")
		{
			$TargetURI = $BASE_URI+"/cname/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter            
		} 
        elseif($Activity -eq "DELETECNAME")
		{
			$TargetURI = $BASE_URI+"/cname/{0}/vip/{1}/{2}/{3}/{4}" -f $CNAME,$VipName,$Area,$NetworkType,$DataCenter
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
            return $response.Content | ConvertFrom-Json
		} 
		catch 
		{
			$ErrorMessage = $_ 		
            $Message = "[E] : Request Failed - $ErrorMessage "

            Write-Output $Message
		}
        return $null
		
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
            # Case 1: CreateVIP & DNS  
            #      Call CreateVIP followed by CreateDNS
            # Case 2: DelteVIP
            #      Call DeleteDNS followed by DeleteVIP

            # Delete DNS before deleting the VIP
            if($Activity -eq "DELETEVIP" -and $FQDN -ne $null)
            {  
                Write-Output "Calling ATM Delete DNS API with parameters: "
                          
                $deleteDnsUri = $BASE_URI+"/dns/{0}/{1}/{2}/{3}" -f $VipName,$Area,$NetworkType,$DataCenter                
		        Write-Output "URI  : $deleteDnsUri "
	
                CallAPI -uri $deleteDnsUri -body $null -userName $LoggedInUserName -verb $TargetVerb	
            }
                 
			# Call ATM API
            $returnValue = CallAPI -uri $TargetURI -body $Body -userName $LoggedInUserName -verb $TargetVerb	
            $returnValue		
            
            # Create DNS 
            if($Activity -eq "CREATEVIP" -and $FQDN -ne $null -and $returnValue -ne $null)
            {     
                $VipName = $returnValue.Name

                $VipName
                Write-Output "Calling ATM Create DNS API with parameters: "
                                    
                $createDns = $BASE_URI+"/dns/{0}/{1}/{2}/{3}" -f $VipName.Trim(),$Area,$NetworkType,$DataCenter
                Write-Output "URI  : $createDns "

                $Body = @"
"$FQDN"
"@
                CallAPI -uri $createDns -body $Body -userName $LoggedInUserName -verb $TargetVerb
            }
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