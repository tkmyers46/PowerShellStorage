
ipmo D:\FIMSVC\Scripts\FimCmdlets.dll

Get-FIMObject -Filter "/*[ObjectID='f7198a7c-98ec-4004-b8d1-48577bad7ea2']" -Attributes * | Select-Object -Property *, `
 @{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Requestor)']" | select -expand accountName}},
 @{Name = 'UserStatus';  Expression = {Get-FimObject -Attributes RegistrationStatus -Filter "/Person[ObjectID='$($_.Requestor)']"  | select -expand RegistrationStatus}}|.
 @{Name = 'User'; Expression = {Get-FimObject -Attributes accountname -Filter "/Person[ObjectID='$($_.Requestor)']" | select -expand accountName}},
 @{Name = 'UserStatus';  Expression = {Get-FimObject -Attributes RegistrationStatus -Filter "/Person[ObjectID='$($_.Requestor)']"  | select -expand RegistrationStatus}}|`
select 'User','UserStatus', CreatedTime
