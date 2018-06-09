 
get-aduser useralias | Export-CSV 'C:\filepath\ExportObject.csv'
Get-ADUser -filter {(mail -eq "*") -and (sn -eq "lastname")} | Export-CSV 'C:\filepath\ExportObject.csv'
Get-ADUser -Filter 'Name -like "useralias"' | Export-CSV 'C:\filepath\ExportObject.csv'
Get-ADObject -Filter 'Name -like "useralias"' -Server 'domain.contoso.com'
Get-ADObject -Filter 'Name -like "useralias"' -Searchbase 'DC=domain,DC=contoso,DC=com' 
Get-ADObject -Filter 'Name -like "useralias"' -Searchbase 'OU=UserAccounts,DC=domain,DC=contoso,DC=com' | Export-CSV 'C:\filepath\ExportObject.csv'
