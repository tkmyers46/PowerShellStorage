ipmo d:\fimSvc\scripts\FimCmdlets.dll

Get-FIMObject -Filter "/Approval[ApprovalStatus='Pending']" -Attributes ObjectType, CreatedTime, Approver, Requestor,ApprovalStatus, EndPointAddress `
 | Where-Object EndPointAddress -like '*5a5721d7-ad3f-473d-8de7-6ee969224e4c/442*' `
 | Select-Object -Property *, `
 @{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Requestor)']" | select -expand accountName}},
 @{Name = 'MGR';  Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Approver)']"  | select -expand accountName}} | `
select 'MGR','User',CreatedTime, ApprovalStatus,Requestor | Export-Csv C:\Users\udvurum\Desktop\PendingApprovalsNew.csv 