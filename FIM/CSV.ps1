Import-Csv C:\Users\udvurum\Desktop\DeleteUsers.csv |
    ForEach-Object {
        $Requestor = $_.User

        cd C:\Users\udvurum\Desktop\Scripts
         .\DeletePerson.ps1 -fimtype Person -attributeName AccountName -requestor $Requestor
        
    }