ipmo D:\FIMSVC\Scripts\FimCmdlets.dll

Get-FIMObject -Filter "/Approval[ApprovalStatus='Pending']" -Attributes ObjectType, CreatedTime, Approver, Requestor,ApprovalStatus, EndPointAddress|
where-object Approver
 Select-Object -Property *, `
 @{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Requestor)']" | select -expand accountName}},
 @{Name = 'MGR';  Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Approver)']"  | select -expand accountName}},
 @{Name = 'UserStatus';  Expression = {Get-FimObject -Attributes RegistrationStatus -Filter "/Person[ObjectID='$($_.Requestor)']"  | select -expand RegistrationStatus}}|`
select 'MGR','User','UserStatus', CreatedTime, ApprovalStatus,Requestor | Format-Table 'MGR','User','UserStatus',CreatedTime, ApprovalStatus -AutoSize

