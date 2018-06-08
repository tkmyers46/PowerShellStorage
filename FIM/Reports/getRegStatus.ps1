
ipmo D:\FIMSVC\Scripts\FimCmdlets.dll

Get-FIMObject -Filter "/Person[RegistrationStatus='complete']" -Attributes AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email |
select AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email |
Format-Table AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email -AutoSize