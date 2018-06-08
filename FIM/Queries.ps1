ipmo D:\FIMSVC\Scripts\FimCmdlets.dll

if(@(get-pssnapin | where-object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {add-pssnapin FIMAutomation}

##Get-FIMObject -Filter "/Person[AccountName='udvurum']" -Attributes *

Get-FIMObject -Filter "/*[ObjectID='66f256a2-8ff4-4fe2-8081-977714af251a']" -Attributes * | Select-Object -Property *

##Get-FIMObject -Filter "/*[ObjectID='5a5721d7-ad3f-473d-8de7-6ee969224e4c']" -Attributes * | Select-Object -Property *
 

##Get-FIMObject -Filter "/*[DisplayName like '%Approval%']" -Attributes * | Select-Object -Property *

##Get-FIMObject -Filter "/*[ObjectID like '68132%']" -Attributes * | Select-Object -Property *

##Get-FIMObject -Filter "/*[ObjectID like '68132%']" -Attributes * | Select-Object -Property *

##Get-FIMObject -Filter "/Person[ObjectSID ='S-1-5-21-2146773085-903363285-719344707-1896765']" -Attributes *


##Get-FIMObject -Filter "/Person[EmployeeID='955701']" -Attributes *



