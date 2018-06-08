<#
.Synopsis
Queries a computer to check for MFA events

.DESCRIPTION
This script will look for NPS events on a given server or set of servers.  

By default the output is shown in table format with limited data. 
Drilling down further to get more verbose event details is also possible via the TimeStamp parameter

.NOTES   
Name: Get-MFAEvents_ro
Author: RandyO [extended by Joeaug]
Version: 2.0
DateUpdated: 2014-04-08

.PARAMETER Server
The string or array of strings to query against.

.PARAMETER MFAServerGroup
Used for easier grouping of MFA servers.  Valid options are:
    Americas | ROW | All

.PARAMETER SearchQuery
The string used to search for.

.PARAMETER TimeStamp
Date/Time used to pull more verbose event details.

This can be used with -Server or -NpsServerGroup

.PARAMETER OutputObject
Will send output as global variable that can be manipulated further

.EXAMPLE
.\Get-MFAEvents_ro.ps1 -Server CO1-PFA-002 -SearchQuery pchacon@microsoft.com

PS C:\users\v-dnnewm\desktop\scripts> .\Get-MFAEvents_ro.ps1 -Server CO1-PFA-002 -searchquery mszaman@microsoft.com
checking CO1-PFA-002 ... Found 21 Auth entries  Found 0 Radius entries

DTimeStamp           ServerName      MessageType  ProcessID  ThreadID  Function  Message
----------           ----------      -----------  ---------  --------  --------  -------
2014-09-17 22:13:14  CO1-PFA-002     0            1648       8648      pfAuth    emailAddress='mszaman@microsoft.com'
2014-09-17 22:13:14  CO1-PFA-002     0            1648       8648      pfAuth    username='mszaman@microsoft.com'
2014-09-17 22:13:14  CO1-PFA-002     i            1648       8648      pfsvc     Username 'REDMOND\mszaman' canonicalized as 'mszaman@microsoft.com'.
2014-09-17 22:17:40  CO1-PFA-002     i            1648       8752      pfsvc     Username 'REDMOND\mszaman' canonicalized as 'mszaman@microsoft.com'.
2014-09-17 22:17:40  CO1-PFA-002     0            1648       8752      pfAuth    emailAddress='mszaman@microsoft.com'
2014-09-17 22:17:40  CO1-PFA-002     0            1648       8752      pfAuth    username='mszaman@microsoft.com'
2014-09-17 23:21:07  CO1-PFA-002     i            1648       8720      pfsvc     Username 'REDMOND\mszaman' canonicalized as 'mszaman@microsoft.com'.
2014-09-17 23:21:07  CO1-PFA-002     0            1648       8720      pfAuth    emailAddress='mszaman@microsoft.com'
2014-09-17 23:21:07  CO1-PFA-002     0            1648       8720      pfAuth    username='mszaman@microsoft.com'

Description:
Will display basic information for events found matching the search query on the server(s) specified.

.EXAMPLE
.\Get-MFAEvents_ro.ps1 -MFAServerGroup Americas -SearchQuery mszaman@microsoft.com

Description:
Will display basic information for events found matching the search query on all NPS servers located in the Americas

.EXAMPLE
.\Get-NPSEvents.ps1 -SearchQuery pchacon@microsoft.com -TimeStamp "4/8/2014 1:21:14 PM"

checking TK5-RADWR01 ...

TimeCreated  : 4/8/2014 1:21:14 PM
ProviderName : Microsoft-Windows-Security-Auditing
Id           : 6278
Message      : Network Policy Server granted full access to a user because the host met the defined health policy.

               User:
                   Security ID:            S-1-5-21-2127521184-1604012920-1887927527-2032793
                   Account Name:            pchacon@microsoft.com
                   Account Domain:            REDMOND
                   Fully Qualified Account Name:    redmond.corp.microsoft.com/UserAccounts/Pablo Chacon Galarraga

               Client Machine:
                   Security ID:            S-1-0-0
                   Account Name:            -
                   Fully Qualified Account Name:    -
                   OS-Version:            -
                   Called Station Identifier:        65.55.31.234
                   Calling Station Identifier:        66.235.53.130

               NAS:
                   NAS IPv4 Address:        172.23.228.6
                   NAS IPv6 Address:        -
                   NAS Identifier:            CO1VPNV20
                   NAS Port-Type:            Virtual
                   NAS Port:            3011

               RADIUS Client:
                   Client Friendly Name:        co1-pfa-006
                   Client IP Address:            10.220.180.162

               Authentication Details:
                   Connection Request Policy Name:    VPN with PhoneFactor
                   Network Policy Name:        New - VPN with PhoneFactor
                   Authentication Provider:        Windows
                   Authentication Server:        TK5-RADWR01.redmond.corp.microsoft.com
                   Authentication Type:        PEAP
                   EAP Type:            Microsoft: Smart Card or other certificate
                   Account Session Identifier:        3333353138

               Quarantine Information:
                   Result:                Full Access
                   Extended-Result:            -
                   Session Identifier:            -
                   Help URL:            -
                   System Health Validator Result(s):    -

Description:
Will display full event details for events matching the search query and date/time on the server(s) specified.
This can be used with -Server or -NpsServerGroup
#>

param (
    [ValidateSet("Americas", "ROW", "All")]
    [string]$MfaServerGroup,
    
    [Parameter(mandatory=$true)]
    [string]$SearchQuery,
    
    [String[]]$Server="$env:COMPUTERNAME",
    
    [datetime]$TimeStamp,

    [switch]$OutputObject
)

#$path = Split-Path -parent $MyInvocation.MyCommand.Definition
#. $path\nps-common.ps1

. \\msitdautil\Share\Scripts\PS\RemoteAccess\MFA\mfa-common.ps1

$mfaAll = $null
if ($MfaServerGroup) {
    switch ($MfaServerGroup) {
        "Americas" {$mfaAll = $mfaAmericas; break}
        "ROW"      {$mfaAll = $mfaROW; break}
        "All"      {$mfaAll = $mfaAmericas + $mfaROW; break}
    }
} else {
    $mfaAll = $Server
}

$ErrorActionPreference = 'SilentlyContinue'

$AllEvents = @()

foreach ($mfaServer in $mfaAll) {
	Write-Host -f yellow "checking $mfaServer ... " -NoNewline
    $ServerTest = Test-Path "\\$mfaServer\c$\Program Files"
    if ($ServerTest) {
	    $AuthSvc = get-content "\\$mfaServer\c$\Program Files\Multi-Factor Authentication Server\Logs\MultiFactorAuthSvc.log" | Select-String $SearchQuery
        $RadiusSvc = Get-Content "\\$mfaServer\c$\Program Files\Multi-Factor Authentication Server\Logs\MultiFactorAuthRadiusSvc.log" | Select-String $SearchQuery
    
        if ($AuthSvc -or $RadiusSvc) {
            ##-- No Timestamp so just show all events in table format
	        #$events | ft TimeCreated, Id, @{Expression={$_.Properties[18].Value};Label="Network Policy";}, @{Expression={$_.Properties[17].Value};Label="Connection Request Policy";}, Message -AutoSize
            Write-Host Found $AuthSvc.length Auth entries -ForegroundColor Green -NoNewline
            Write-Host `tFound $RadiusSvc.length Radius entries -ForegroundColor Green
            foreach ( $mLine in $AuthSvc) {
                $splitLine = $mLine -split "\|"
                $AllEvents += [pscustomobject] @{
                    DTimeStamp = $splitLine[0]
                    ServerName = $mfaServer.ToUpper()
                    MessageType = $splitLine[1]
                    ProcessID = $splitLine[2]
                    ThreadID = $splitLine[3]
                    Function = $splitLine[4]
                    Message = $splitLine[5]
                }
            }
            foreach ( $mLine in $RadiusSvc) {
                $splitLine = $mLine -split "\|"
                $AllEvents += [pscustomobject] @{
                    DTimeStamp = $splitLine[0]
                    ServerName = $mfaServer
                    MessageType = $splitLine[1]
                    ProcessID = $splitLine[2]
                    ThreadID = $splitLine[3]
                    Function = $splitLine[4]
                    Message = $splitLine[5]
                }
            }
        #$AllEvents += $AuthSvc
        #$AllEvents += $RadiusSvc
	        } else {
	            Write-Host "Didn't find any entries on $mfaServer for $SearchQuery" -ForegroundColor Red
	        }
        } else {
            Write-Host "Couldn't Connect" -ForegroundColor Red
        }
}

$Global:Events = $AllEvents | Sort-Object -property DTimeStamp
$originalColor = $Host.UI.RawUI.ForegroundColor 

$AllEvents | Sort-Object -property DTimeStamp | ft -Property @{e={$(Get-Date ($_.DTimeStamp) -Format "yyyy-MM-dd HH:mm:ss")};n="DTimeStamp";width=20}, `
    @{Label="ServerName"; Expression={$($_.ServerName)};width=15}, `
    @{Label="MessageType"; width=12; Expression={ if ($_.MessageType -eq "e"){$Host.ui.rawui.ForegroundColor = "Red" ; $_.MessageType}
        ELSEIF ($_.MessageType -eq "i") {$Host.ui.rawui.ForegroundColor = "Yellow" ; $_.MessageType}
        ELSE {$Host.ui.rawui.ForegroundColor = $originalColor ; $_.MessageType}}}, `
    @{Label="ProcessID"; Expression={$($_.ProcessID)}; width=10}, `
    @{Label="ThreadID"; Expression={$($_.ThreadID)}; width=9}, `
    @{Label="Function"; Expression={$($_.Function)}; width=9}, `
    @{Label="Message"; Expression={$($_.Message)}; width=250} 

$Host.UI.RawUI.ForegroundColor = $originalColor
<#
$Headers = $(@"
DTimeStamp
MessageType
ProcessID
ThreadID
Function
Message
"@) -split "\r\n|\n"

$AllEventsTable = ConvertFrom-Csv -InputObject $AllEvents -Delimiter '|' -Header $Headers
$AllEventsTable | Sort-Object $_.DTimeStamp | Select @{e={$(Get-Date ($_.DTimeStamp) -Format "yyyy-MM-dd HH:mm:ss")};n="DTimeStamp"}, `
    @{e={$($_.MessageType)};n="MessageType"}, `
    @{e={$($_.ProcessID)};n="ProcessID"}, `
    @{e={$($_.ThreadID)};n="ThreadID"}, `
    @{e={$($_.Function)};n="Function"}, `
    @{e={$($_.Message)};n="Message"} | `
ft -AutoSize -Wrap


#if ($TimeStamp) {
#    $AllEvents | where TimeCreated -Match $TimeStamp | fl
#} elseif ($OutputObject) {
#    $Global:NPSEvents = $AllEvents
##    $Global:NPSEventsFormat = @{Expression={$_.MachineName.ToUpper().Split(".")[0]};Label="MachineName";}, "TimeCreated", "Id", @{Expression={$_.Properties[18].Value};Label="Network Policy";}, @{Expression={$_.Properties[17].Value};Label="Connection Request Policy";}, "Message";
#    Write-Host "Access results in the `$NPSEvents object"
#} else {
#    $AllEvents | Sort-Object TimeCreated -Descending | ft @{Expression={$_.MachineName.ToUpper().Split(".")[0]};Label="MachineName";}, TimeCreated, Id, @{Expression={$_.Properties[18].Value};Label="Network Policy";}, @{Expression={$_.Properties[17].Value};Label="Connection Request Policy";}, Message -AutoSize
#}
#>