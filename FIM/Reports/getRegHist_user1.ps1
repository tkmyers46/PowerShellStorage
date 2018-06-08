
param($userName ='ronniet')
###
### Load the FimCmdlets module
###
ipmo d:\fimSvc\scripts\FimCmdlets.dll

#$uDate=(get-date).ToUniversalTime().addDays($dRange)
#$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00

Get-FIMObject -Attributes * -Filter  "/WtfcRecord[WtfcUser = /Person[AccountName='$userName']]" | 
Select-Object -Property *,
@{Name ="eDate"; Expression = {(Get-Date $_.CreatedTime).ToLocalTime()}},
@{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand accountName}} | select * | 
Sort-Object 'eDate' |
Format-Table 'eDate','user',WtfcCode,WtfcStatus,WtfcProcessType -AutoSize
