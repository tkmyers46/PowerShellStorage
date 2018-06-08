Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId 6f5479b6-b447-4dc8-9102-76ef50cfec22

$pfxFilePath = 'C:\Users\TRMYE\Downloads\sspmuat.corp.microsoft.com.pfx'
$pwd = '!!**5439mK'
$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection 
$collection.Import($pfxFilePath, $pwd, $flag)
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12
$clearBytes = $collection.Export($pkcs12ContentType)
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes)
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force
$secretContentType = 'application/x-pkcs12'
Set-AzureKeyVaultSecret -VaultName 'sspmdevakv' -Name 'sspmcert' -SecretValue $Secret -ContentType $secretContentType
Select-AzureSubscription -SubscriptionId 6f5479b6-b447-4dc8-9102-76ef50cfec22
Get-AzureRmKeyVault