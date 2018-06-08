###-
### T::Load the FimCmdlets module
###
ipmo d:\fimSvc\scripts\FimCmdlets.dll

###
### Create a session to the Phone Registration FIM Service computer
###
## $sesh = New-FIMSession -Server 'CO1-IAMSQL-VM01'
##  and WtfcStatus = 'Error' and WtfcDetails = 'Your request timed out.'
## "/WtfcRecord[CreatedTime >= '2014-09-04' and WtfcStatus = 'Error' and WtfcDetails = 'Your request timed out.']"
## "/WtfcRecord[CreatedTime >= '2014-09-04' and WtfcStatus = 'complete' and WtfcProcessType ='registration']"

##$SQLconn = New-Object System.Data.SqlClient.SqlConnection
##$SQLconn.ConnectionString = "Server=CO1-IAM-1413.redmond.corp.microsoft.com;Database=metricsOps;Integrated Security=True"
##$SQLconn.Open()

#$uDate=(get-date).ToUniversalTime().addHours(-24)
#$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00

$uDate=(get-date).ToUniversalTime().addHours(-2)
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00
Get-FIMObject -Attributes * -Filter "/WtfcRecord[CreatedTime >= '$udate' and WtfcStatus = 'Error' and WtfcDetails = 'Your request timed out.']"  | 
Select-Object -Property *,
@{Name ="eDate"; Expression = {(Get-Date $_.CreatedTime).ToLocalTime()}},
@{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand accountName}} | select 'eDate',wtfcuser,User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode |
 Format-Table 'eDate',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode -AutoSize