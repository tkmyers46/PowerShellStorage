param($userName,
$historyhours)

### .ToLocalTime()
### Load the FimCmdlets module
###
ipmo d:\fimSvc\scripts\FimCmdlets.dll
###
### Create a session to the Phone Registration FIM Service computer
###
#$sesh = New-FIMSession -Server 'CO1-IAM-1412' 

###
### Get all WtfcRecords for 'cmmbx2' since '2014-09-02T00:00:00' (UTC)
###
If ($historyhours -eq $null) {$uDate=(get-date).ToUniversalTime().addHours(-2000)}
    else {$uDate=(get-date).ToUniversalTime().addHours(-$historyhours)}
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00

If ($userName -eq $null) {$userName='sergekou'}

Get-FIMObject -Attributes * -Filter  "/WtfcRecord[WtfcUser = /Person[AccountName='$userName'] and CreatedTime >= '$udate']" | 
Select-Object -Property *,
@{Name ="eDate"; Expression = {(Get-Date $_.CreatedTime)}},
@{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand accountName}} | select 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode | 
#export-csv "D:\FIMSVC\Scripts\phoneReg.csv"
Sort-Object 'eDate' | 
Format-Table 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode -AutoSize