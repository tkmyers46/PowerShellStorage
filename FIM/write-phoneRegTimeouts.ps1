### Load the FimCmdlets module
ipmo d:\fimSvc\scripts\FimCmdlets.dll

### Configure logging
$eventLog = 'phoneRegistration'
$EventLogSource = 'TimeOut'
$eventID = 5000
$eventType = 'error'

### check to see if the PhoneRegistration eventLog exists
$e =get-eventlog -list
if ($e.Log -eq $false) {new-eventlog -logname $eventLog -Source $EventLogSource}

### check to see if the PhoneRegistration TimeOut eventSource exists
if ([System.Diagnostics.EventLog]::SourceExists($EventLogSource) -eq $false) {
    [System.Diagnostics.EventLog]::CreateEventSource($EventLogSource, "TimeOut")
}

### write to phoneRegistration EventLog
Function Write-Log($EventID,$EntryType,$Message)
{
  write-eventlog -logname phoneRegistration -source $EventLogSource -eventID $EventID -entrytype $eventType -message $Message
}

### set the date; past 1 hours
$uDate=(get-date).ToUniversalTime().addHours(-1)
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00

## set the query: just want to get the count
$d = Get-FIMObject -Filter "/WtfcRecord[CreatedTime >= '$udate' and WtfcStatus = 'Error' and WtfcDetails = 'Your request timed out.']"
$message = $d.count

### raise event
if ($message -ne 0)
    {write-log -EventID $eventID -EntryType $eventType -Message "$message timeouts have occurred"}
else
    {write-host $message}