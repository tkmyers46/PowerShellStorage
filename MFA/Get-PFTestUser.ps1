#
# Get Phone Factor User objects - query both FIM and PF
#
# Use between test cases to reset the environment
#
param([string] $UserIdentityArg = "", [string] $ActionArg = "RemoveAll")

#
# Get the user identity
#
$PersonAlias = ""
$PersonEmail = ""
if($UserIdentityArg -eq "")
{
	Write-host "Please specify the user identity to reset on the command line" -foregroundcolor yellow
	exit
}
$AccountNameRegex = "^(.+)@"
if($UserIdentityArg -match $AccountNameRegex)
{
	#
	# an email name was specified
	#
	$PersonEmail = $UserIdentityArg
	$PersonAlias = $matches[1]
}
else
{
	#
	# A short name (alias) was specified
	#
	$PersonAlias = $UserIdentityArg
	$PersonEmail = "$UserIdentityArg@microsoft.com"
}
Write-host "Processing $PersonEmail ($PersonAlias)"

function LoadFIMPowerShell()
{
	#
	# Setup for FIM PowerShell
	#
	### Load the FIM PowerShell Snap-in
	try
	{
		Add-PSSnapin fimautomation -erroraction stop
	}
	catch
	{
		#
		# do nothing - just avoiding red exception text 
		#
	}

	### Load the FimPowerShellModule (CodePlex)
	Import-Module C:\PhoneRegistration\FimPowerShellModule.psm1
}

function GetUserObjectFromFIM()
{
	#
	# Get a user object from FIM
	#
	param([string]$PersonEmailArg)

	#
	# Query  for the user
	#
	$TempAccountParm = "/Person[AccountName='$PersonEmailArg']" 
	$TargetUser = Export-FIMConfig -only -custom $TempAccountParm | Convert-FimExportToPSObject
	if($TargetUser -eq $null)
	{
		Write-Host "User: $PersonEmailArg doesn't exist in FIM." -foregroundcolor yellow
	}
	else
	{
		$TargetUser
	}
}

function LoadPFUtilDLL()
{
	#
	# Setup for Phone Factor Web SDK calls
	#
	$PFClientFolder='C:\PhoneAuthentication\PhoneAuthenticationGate'
	$PFClientDLLPath= Join-Path $PFClientFolder 'MS.IT.PhoneAuth.PFClient.dll'
	$PFAgentURL = 'https://reggietestagent.corp.microsoft.com/phonefactorwebservicesdk/PfWsSdk.asmx'
	if(Test-Path($PFClientDLLPath))
	{
		# 
		# Load the MS.IT.PhoneAuth.PFClient.dll DLL 
		# Note: it does NOT need to be installed or registered, just the file itself is enough 
		# 
		Add-Type -Path $PFClientDLLPath

		# 
		# Point to the PhoneFactor URL 
		# 
                $global:PfUtil = New-Object MS.IT.PhoneAuth.PFClient.PFUtil -ArgumentList $PFAgentURL 
	}
	else
	{
		Write-host "Cannot find  PF Client DLL at: $PFClientDLLPath" -foregroundcolor yellow
		Write-host "Please fix the problem and rerun the script." -foregroundcolor yellow
		exit
	}
	Write-Host "Using PF Agent at:" $($global:PfUtil.PhoneFactorWebServiceUri).ToString()

}
function GetUserFromPhoneFactor()
{
	param([string]$PersonEmailArg)

	# 
	# Retrieve a user from Phone Factor
	#
	$TargetUser = $null
	$TargetUser = $global:PfUtil.FindUsersByUsername("$PersonEmailArg", "") 
	if($TargetUser -eq $null)
	{
		Write-Host "User: $PersonEmailArg doesn't exist in Phone Factor agent." -foregroundcolor yellow
	}
	else
	{
		Write-Host "Located $PersonEmailArg in Phone Factor"
		$TargetUser
	}
}

function GetUserSettingsFromPhoneFactor()
{
	param([string]$PersonEmailArg)

	# 
	# Get user settings from Phone Factor
	#
	$TargetUser = $null
	$TargetUser = $global:PfUtil.FindUsersByUsername("$PersonEmailArg", "") 
	if($TargetUser -eq $null)
	{
		Write-Host "User: $PersonEmailArg doesn't exist in Phone Factor agent." -foregroundcolor yellow
	}
	else
	{
		Write-Host "Locating $PersonEmailArg in Phone Factor"
		$global:PfUtil.GetUserSettings("$PersonEmailArg")
	}
}

Write-Host "================================================================="
Write-Host "                               FIM"
Write-Host "================================================================="
LoadFIMPowerShell
GetUserObjectFromFIM $PersonAlias
Write-Host "================================================================="
Write-Host "                          Phone Factor"
Write-Host "================================================================="
LoadPFUtilDLL
GetUserFromPhoneFactor $PersonEmail
GetUserSettingsFromPhoneFactor $PersonEmail


