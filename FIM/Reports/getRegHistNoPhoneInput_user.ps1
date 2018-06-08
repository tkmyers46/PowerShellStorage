param($userName)

###
### Load the FimCmdlets module
###
ipmo .\FimCmdlets.dll
###
### Create a session to the Phone Registration FIM Service computer
###
### $sesh = New-FIMSession -Server 'CO1-IAM-1412' 

$uDate=(get-date).ToUniversalTime().addHours(-48)
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00

$userName='ronniet'

Get-FimObject -Attributes * -Filter  "/WtfcRecord[WtfcUser = /Person[AccountName='$userName'] and WtfcStatus = 'Error' and WtfcDetails = 'No Phone Input - Timed Out']" | 
Select-Object -Property *,
@{Name ="eDate"; Expression = {(Get-Date $_.CreatedTime).ToLocalTime()}},
@{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand accountName}} | select 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode |
Sort-Object 'eDate' | 
Format-Table 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode -AutoSize
