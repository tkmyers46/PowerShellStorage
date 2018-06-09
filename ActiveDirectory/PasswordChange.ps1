
## If ADDS isn't installed on the local machine
## Install-Module -name AD-Domain-Services
Import-Module activedirectory

$oldPassword = ConvertTo-SecureString '<oldpassword>' -AsPlainText -Force
$newPassword = ConvertTo-SecureString '<newpassword>' -AsPlainText -Force
$domain = ConvertTo-SecureString 'domain.contoso.com' -AsPlainText -Force
Set-ADAccountPassword -Identity useralias -OldPassword $oldPassword -NewPassword $newPassword
Set-ADAccountPassword -Server $domain -Identity useralias -OldPassword $oldPassword -NewPassword $newPassword
Set-ADAccountPassword -Identity useralias -OldPassword $oldPassword -NewPassword $newPassword -Partition 'DC=domain, DC=contoso, DC=com'
Get-Help Set-ADAccountPassword -Examples
Set-ADAccountPassword 'DC=domain, DC=contoso, DC=com' -Identity useralias -OldPassword $oldPassword -NewPassword $newPassword
