ipmo d:\fimsvc\scripts\FimCmdlets.dll

Get-FIMObject -Attributes * -Filter  "/WtfcRecord[CreatedTime >= '2015-01-01T00:00:00' and WtfcStatus = 'Error' and WtfcDetails = 'Your request timed out.']"  |
Select-Object -Property *,
@{Name ="LocalTime (PST)"; Expression = {(Get-Date $_.CreatedTime).ToLocalTime()}},
@{Name = 'User';           Expression = {Get-FimObject -Attributes DisplayName -Filter "/Person[ObjectID='$($_.WtfcUser)']" | select -expand DisplayName}} |
Sort-Object CreatedTime |
Format-Table 'LocalTime (PST)',User, WtfcProcessType, WtfcStatus, WtfcDetails, WtfcCode -AutoSize