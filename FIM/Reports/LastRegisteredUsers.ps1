ipmo d:\fimSvc\scripts\FimCmdlets.dll


If ($historyhours -eq $null) {$uDate=(get-date).ToUniversalTime().addHours(-2000)}
    else {$uDate=(get-date).ToUniversalTime().addHours(-$historyhours)}
$uDate = Get-Date $udate -format yyyy'-'MM'-'ddTH:00:00


Get-FIMObject -Filter "/Person[RegistrationStatus='complete' and LastRegistrationDate >= '$udate']" -Attributes AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email |
select AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email |
Format-Table AccountName,RegistrationWithAuthZ,LastRegistrationDate,Email -AutoSize
 