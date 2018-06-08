
## If ADDS isn't installed on the local machine
## Install-Module -name AD-Domain-Services
Import-Module activedirectory

$oldPassword = ConvertTo-SecureString 'Almond2016' -AsPlainText -Force
$newPassword = ConvertTo-SecureString 'Peanut2016' -AsPlainText -Force
$domain = ConvertTo-SecureString 'fareast.corp.microsoft.com' -AsPlainText -Force
Set-ADAccountPassword -Identity pftst3a -OldPassword $oldPassword -NewPassword $newPassword
Set-ADAccountPassword -Server $domain -Identity pftst3a -OldPassword $oldPassword -NewPassword $newPassword
Set-ADAccountPassword -Identity pftst3a -OldPassword $oldPassword -NewPassword $newPassword -Partition 'DC=fareast, DC=corp, DC=microsoft, DC=com'
Get-Help Set-ADAccountPassword -Examples
Set-ADAccountPassword 'DC=fareast, DC=corp, DC=microsoft, DC=com' -Identity acu523f -OldPassword $oldPassword -NewPassword $newPassword
