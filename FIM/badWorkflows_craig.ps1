


<#

http://co1-iam-1412:5726/ResourceManagementService/WorkflowManager/9ae686b3-0390-4e74-8372-5306fb06c2e0/287
http://co1-iam-1412:5726/ResourceManagementService/WorkflowManager/5a5721d7-ad3f-473d-8de7-6ee969224e4c/329
#>
ipmo D:\FIMSVC\Scripts\FimCmdlets.dll

Get-FIMObject -Filter "/*[ObjectID='5a5721d7-ad3f-473d-8de7-6ee969224e4c']" -Attributes *

Get-FIMObject -Filter "/Approval[ApprovalStatus='Pending']" -Attributes * | select -first 5 -Property ApprovalStatus

Get-FIMObjectCount -Filter "/Approval[ApprovalStatus='Pending']"

Get-FIMObject -Filter "/Approval[ApprovalStatus='Pending']/Approver" -Attributes *  # DisplayName,AccountName

Get-FIMObject      -Filter "/Approval[ApprovalStatus='Pending']/Requestor" -Attributes DisplayName,AccountName | Group-Object AccountName 
Get-FIMObjectCount -Filter "/Approval[ApprovalStatus='Pending']/Requestor"

Get-FIMObject -Filter "/Approval" -Attributes * | select -first 2
Get-FIMObject -Filter "/Approval[ApprovalStatus='Pending']" -Attributes ObjectType, CreatedTime, Approver, Requestor,ApprovalStatus, EndPointAddress | Where-Object EndPointAddress -like '*9ae686b3-0390-4e74-8372-5306fb06c2e0*' | select ObjectType, CreatedTime, Approver, Requestor,approvalstatus

$BadApprovals.count

$BadApprovals | Select-Object EndpointAddress

$BadApprovals | Out-GridView