ipmo d:\fimSvc\scripts\FimCmdlets.dll


##Get-FIMObject -Filter "/Person[RegistrationStatus='Canceled']" -Attributes AccountName,RegistrationStatus,RegistrationWithAuthZ,LastRegistrationDate,Email | Export-Csv C:\Users\udvurum\Desktop\info.csv 

Get-FIMObject -Filter "/Person[ObjectID=/Set[DisplayName='PhoneRegistration: Services disabled']/ComputedMember]" -Attributes AccountName,DisplayName,UserPrincipalName,RegistrationStatus,LastRegistrationDate,EmployeeID,Email | Export-Csv C:\Users\udvurum\Desktop\DisabledUsers.csv 

