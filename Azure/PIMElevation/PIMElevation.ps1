<#
.Synopsis
    The script will PIM elevate you to global administrator to the Microsoft tenant of AAD. 
    This is command line equivalent to going to Azure portal UI and requesting elevation; https://ms.portal.azure.com/
.DESCRIPTION
    There are no parameters only read-hosts. This script ask the user for 1 input; reason for elevation to global administrator. 
.EXAMPLE
    Don't put double quotes around the reason you input
    ----------------------------------
    Input your reason to elevate: for AAD Onboarding/App Configuration
#>
<#
Parameters
    No Parameters just read-hosts
#>
#Author
#    ytisoni
#Change History
#     6/15/2016 - initial script
#     6/15/2016 - Added code to get the current username so you don't need to input it

#Install-Module -Name Microsoft.Azure.ActiveDirectory.PIM.PSModule

#region - Initializing global variables

#this guid is for company administrator
$roleGUID = "62e90394-69f5-4237-9190-012177145e10"

#endregion

try
{
    Write-Host "You are executing the PIM elevation tool to elevate to global admin to the MS AAD Tenant" -ForegroundColor Green
    $elevationReason = Read-Host "Input your reason to elevate"
    
    $userName = [Environment]::UserName
    #concatenating @microsoft.com as we only have those UPNs as GA
    $UPN = $userName + "@microsoft.com"
  
    #connecting to PIM service and then enabling GA elevation
    Connect-PimService -UserName $UPN 
    Enable-PrivilegedRoleAssignment -RoleId $roleGUID -Reason $elevationReason

    #output the user's role assignment to see if the elevation worked
    Write-Host "Your current role assignment" -ForegroundColor Yellow
    $OutputString = Get-PrivilegedRoleAssignment | Out-String
    Write-Host $OutputString -ForegroundColor Yellow
}
Catch
{
    Write-Host "Error Occurred: " $_.exception.message
}