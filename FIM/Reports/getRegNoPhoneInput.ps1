###-
### T::Load the FimCmdlets module
###
ipmo d:\fimSvc\scripts\FimCmdlets.dll

###
### Create a session to the Phone Registration FIM Service computer
###
## $sesh = New-FIMSession -Server 'CO1-IAMSQL-VM01'

$uDate=(get-date).ToUniversalTime().addHours(-2)
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00
$d =Get-FIMObject -Attributes * -Filter "/WtfcRecord[CreatedTime >= '$udate' and WtfcStatus = 'Error' and WtfcDetails = 'No Phone Input - Timed Out']" #  | 
$d.count


#Select-Object -Property *,
#@{Name ="eDate"; Expression = {(Get-Date $_.CreatedTime).ToLocalTime()}},
#@{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand accountName}} | select 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode |
# Format-Table 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode -AutoSize