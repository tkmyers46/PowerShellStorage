PARAM([parameter(Mandatory=$true,Position=0,HelpMessage=”Enter number of months prior")] 
      [Int] 
      $Months,
      [parameter(Mandatory=$true,Position=1,HelpMessage=”Enter number of days prior")] 
      [Int] 
      $Days,
      [parameter(Mandatory=$false,Position=3,HelpMessage=”Enter number of hours prior")] 
      [Int] 
      $Hours
     )


<#
    Name: Delete-WtfcRecord.ps1
    Author: TRMYE
    Credits: Trap/Snapin THADH, FIM PowerShell module Craig Martin
    Date: 7/7/2017
    Purpose: Phone Registration web application logs history events in a FIM database, there's no garbage mechanism.
             
    Syntax: .\Delete-WtfcRecord.ps1 -Months <integer> -Days <integer> -Hours <integer>
    
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
    $errorReport += $($_.Exception.Message) | Export-Csv WtfcDeleteError.csv -Append
    Exit
 }

if (Test-Path C:\Scripts\FimCmdlets.dll) {

Import-Module C:\Scripts\FimCmdlets.dll

}
else {

    Write-Host 'Missing FimCmdlets.dll'
    break

}

$report = @()
$errorReport = @()
$URI = "http://localhost:5725"

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
        if($error) 
        {
            if($error[0].categoryinfo.reason -eq "PSArgumentException")
            {
                write-host "Could not add FIMAutomation PsSnapin" 
                exit 
            }
        }
    }
}

Load-Snapin

# Set the date to 3 years and 8 months ago
$uDate=(get-date).ToUniversalTime().AddMonths($Months).AddDays($Days).AddHours($Hours)

# Format our filter date to WtfcTime formatting
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTHH:mm:ss

# Get the oldest 100 records
$objectsDelete = Get-FIMObject -Filter "/WtfcRecord[WtfcTime < '$uDate']" -Attributes WtfcTime | Sort-Object WtfcTime


while ($objectsDelete.Count -gt 0)
{

    $objectsDelete = Get-FIMObject -Filter "/WtfcRecord[WtfcTime < '$uDate']" -Attributes WtfcTime | Sort-Object WtfcTime | Select-Object -First 100

    # Iterate thru 100 records and delete by object ID
    foreach ($obj in $objectsDelete)
    {
        $ancpairs = @{ObjectID = $obj.ObjectID}        
        New-FimImportObject -ObjectType WtfcRecord -State Delete -AnchorPairs $ancpairs -ApplyNow $true
    }
}

