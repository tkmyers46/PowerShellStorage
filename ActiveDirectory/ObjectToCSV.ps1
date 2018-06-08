cd C:\Users\trmye\Documents\Temp 
get-aduser v-setho | Export-CSV 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\ActiveDirectory\ExportedObjectsCSV\ExportObject.csv'
Get-ADUser -filter {(mail -eq "*") -and (sn -eq "Smith")} | Export-CSV 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\ActiveDirectory\ExportedObjectsCSV\ExportObject.csv'
Get-ADUser -Filter 'Name -like "v-setho"' | Export-CSV 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\ActiveDirectory\ExportedObjectsCSV\ExportObject.csv'
Get-ADObject -Filter 'Name -like "v-setho"' -Server 'redmond.corp.microsoft.com'
Get-ADObject -Filter 'Name -like "v-setho"' -Searchbase 'DC=redmond,DC=corp,DC=microsoft,DC=com' | 
Get-ADObject -Filter 'Name -like "v-setho"' -Searchbase 'OU=UserAccounts,DC=redmond,DC=corp,DC=microsoft,DC=com' | Export-CSV 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\ActiveDirectory\ExportedObjectsCSV\ExportObject.csv'