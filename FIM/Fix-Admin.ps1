PARAM([parameter(Mandatory=$true,Position=0,HelpMessage=”Specify the User's Display Name")] 
      [String] 
      $DisplayName,
      [parameter(Mandatory=$true,Position=1,HelpMessage=”Specify the User's Alias")] 
      [String] 
      $AccountName,
      [parameter(Mandatory=$true,Position=2,HelpMessage=”Specify the User's Domain")] 
      [String] 
      $Domain
     )

<#
    Name: Fix-Admin.ps1
    Author: ThadH
    Credits: GetSidAsBase64() shamelessly stolen from MarkVi
    Date: 5/3/2011
    Purpose: When the FIM portal/service is installed, it uses the credentials of the person installing to create a user
             and to set that user as the only member of the Administrators set in FIM.  This prevents access to the portal
             for others to configure FIM.  There are 2 ways around this: A) get MAs and sync engine configured and flow in
             all users from AD, at which time those users needing adminstrative access can be added to the Administrators 
             set, or B) while logged into the portal with the installers account, create the user, add their objectSID, 
             then add the user to the Administrators set.  This script automates the latter method.
             
    Syntax: .\fix-admin -DisplayName <users displayname> -AccountName <user's alias> -Domain <domain>
    
    Note: if you don't have the FIM Automation assembly installed you'll need to run this from the portal/ws machine. If 
          you do have the FIM Automation assembly installed, you'll need to change the $URI string in MAIN to the appropriate
          target.  Regardless, the script must be executed in the context of the existing user in the Administrator's set.

#>


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Exception handling
#
# --------------------------------------------------------
 trap
 { 
    Write-Host "`nError: $($_.Exception.Message)`n" -foregroundcolor white -backgroundcolor darkred
    Exit
 }
 
 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Load-Snapin
#
# --------------------------------------------------------
function Load-Snapin
{
    PARAM()
    END
    {
        if(@(get-pssnapin | where-object {$_.Name -like "FIMAutomation*"} ).count -eq 0) 
        {
            add-pssnapin FIMAutomation
        }
        if($error[0].categoryinfo.reason -eq "PSArgumentException")
        {
            write-host "Could not add FIMAutomation PsSnapin" 
            exit 
        }
    }
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  GetSIDasBase64 - Retrieves the Base64 encoded SID for the referenced user
#
# --------------------------------------------------------
function GetSidAsBase64
{
    PARAM($AccountName, $Domain)
    END
    {
        $sidArray = [System.Convert]::FromBase64String("AQUAAAAAAAUVAAAA71I1JzEyxT2s9UYraQQAAA==") # This sid is a random value to allocate the byte array
        $args = (,$Domain)
        $args += $AccountName
        $ntaccount = New-Object System.Security.Principal.NTAccount $args
        $desiredSid = $ntaccount.Translate([System.Security.Principal.SecurityIdentifier])
		write-host " -Account SID : ($Domain\$AccountName) $desiredSid"
        $desiredSid.GetBinaryForm($sidArray,0)
        $desiredSidString = [System.Convert]::ToBase64String($sidArray)
        $desiredSidString
    }
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Set-Attribute
#
# --------------------------------------------------------
function Set-Attribute
{
   PARAM([Ref]$CurObject, $AttributeName, $AttributeValue)
   END
   {
       $ImportChange = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportChange
       if($AttributeName -eq "ExplicitMember")
       {
           $ImportChange.Operation = 0
       }
       else
       {
           $ImportChange.Operation = 1
       }
       $ImportChange.AttributeName = $AttributeName
       $ImportChange.AttributeValue = $AttributeValue
       $ImportChange.FullyResolved = 1
       $ImportChange.Locale = "Invariant"
       If($CurObject.Value.Changes -eq $null)
       {
           $CurObject.Value.Changes = (,$ImportChange)
       }
       Else 
       {
           $CurObject.Value.Changes += $ImportChange
       }
   }
} 


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Add-User
#
# --------------------------------------------------------
function Add-User
{
    PARAM($DisplayName,$AccountName,$Domain,$accountSid)
    END
    {
        $exportObject = export-fimconfig -uri $URI -onlyBaseResources -customconfig ("/Person[AccountName='$AccountName']")

        $ImportObject = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject
        If($exportObject -eq $null)
        {
            # if there is no user already in the DB
            $ImportObject.ObjectType = "Person"
            $ImportObject.SourceObjectIdentifier = [System.Guid]::NewGuid().ToString()
            $ImportObject.State = 0
            Set-Attribute ([Ref]$ImportObject) "AccountName" $AccountName
            Set-Attribute ([Ref]$ImportObject) "DisplayName" $DisplayName
            Set-Attribute ([Ref]$ImportObject) "Domain" $Domain
        }
        Else
        {
            $ImportObject.ObjectType = $exportObject.ResourceManagementObject.ObjectType 
            $ImportObject.TargetObjectIdentifier = $exportObject.ResourceManagementObject.ObjectIdentifier 
            $ImportObject.SourceObjectIdentifier = $exportObject.ResourceManagementObject.ObjectIdentifier 
            $ImportObject.State = 1 
        }

        # make sure that there isn't an existing objectsid
        $objectSID = $exportObject.ResourceManagementObject.ResourceManagementAttributes | Where-Object {$_.AttributeName -eq "ObjectSID"}
        if($accountSid -eq $objectSID.Value)
        {
            $ImportObject = $null
            Write-Host "`nThere's already an objectSID for this user!`n"
        }
        else
        {
            Set-Attribute ([Ref]$ImportObject) "ObjectSID" $accountSid
            $importObject | Import-FIMConfig -uri $URI -ErrorVariable Err -ErrorAction SilentlyContinue
            if($Err)
            {
                throw $Err
            }
        }
    }
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Set-Admin
#
# --------------------------------------------------------
function Set-Admin
{
    PARAM($DisplayName,$AccountName,$Domain,$accountSid)
    END
    {
        $myRet = $false
        $exportPerson = export-fimconfig -uri $URI -onlyBaseResources -customconfig ("/Person[AccountName='$AccountName']")
        If($exportPerson -eq $null)
        {
            write-host "User not found; can't set as member of Administrator's set"
        }
        Else
        {
            $usrID = $exportPerson.ResourceManagementObject.ResourceManagementAttributes | where-Object {$_.AttributeName -eq "ObjectID"}
            $exportAdmins = export-fimconfig -uri $uri -onlyBaseResources -customconfig "/Set[DisplayName='Administrators']"
            if($exportAdmins -eq $null)
            {
                write-host "FIM failed to return Administrators set!"
            }
            else
            {
                $admMbr = $exportAdmins.ResourceManagementObject.ResourceManagementAttributes | where-Object {$_.AttributeName -eq "ExplicitMember"}
                if($admMbr.Values -match $usrID.value)
                {
                    write-host "`nUser already a member of Administrators set`n"
                }
                else
                {
                    $ImportObject = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject
            
                    $ImportObject.ObjectType = $exportAdmins.ResourceManagementObject.ObjectType 
                    $ImportObject.TargetObjectIdentifier = $exportAdmins.ResourceManagementObject.ObjectIdentifier 
                    $ImportObject.SourceObjectIdentifier = $exportAdmins.ResourceManagementObject.ObjectIdentifier 
                    $ImportObject.State = 1 
                    Set-Attribute ([Ref]$ImportObject) "ExplicitMember" $usrID.value
                    $importObject | Import-FIMConfig -uri $URI -ErrorVariable Err -ErrorAction SilentlyContinue
                    if($Err)
                    {
                        throw $Err
                    }
                    else
                    {
                        $myRet = $true
                    }
                }
            }
        }
        Return $myRet
    }
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# MAIN
#
# --------------------------------------------------------
     
$error.clear()
$URI = "http://localhost:5725/resourcemanagementservice"

Load-Snapin
$accountSid = GetSidAsBase64 $AccountName $Domain
Add-User $DisplayName $AccountName $Domain $accountSid
$Ret = Set-Admin $DisplayName $AccountName $Domain $accountSid
if($Ret -eq $true)
{
    Write-host "`nSuccess!  Done.`n"
}
else
{
    Write-host "`nCompleted with errors.`n"
}

