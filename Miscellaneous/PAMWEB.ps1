Import-Module "C:\\WebService\\LSClientAgentCommandlets"

$jitWebServiceAddress = "https://jitadminia/ERPMWebService/authservice.svc"
$webServiceAddress = "https://pamweb.corp.microsoft.com:801/ERPMWebService/authservice.svc"
#$webServiceAddress = "https://pamwebsvc.corp.microsoft.com:801/ERPMWebService/authservice.svc"

Set-LSClientWebServiceSettings -EnableWebService $true -WebServiceAddress $webServiceAddress -IntegratedAuth $true -SSLEnabled $true
Set-LSClientWebServiceSettings -EnableWebService $true -WebServiceAddress $jitWebServiceAddress -IntegratedAuth $true -SSLEnabled $true

Set-Alias LNES New-LSEnrollSystem
Set-Alias LSCS Set-LSClientSettings
Set-Alias LGCS Get-LSClientSettings
Set-Alias LGWA Get-LSWebApplicationSettings
Set-Alias LGWAS Get-LSWebApplicationSettings
Set-Alias LTC Test-LSConnection
Set-Alias LT Get-LSLoginToken
Set-Alias LLT Get-LSLoginToken
Set-Alias LGPWR Get-LSPasswordWithoutReason
Set-Alias LGPIC Get-LSPasswordIgnoreCheckout
Set-Alias LGP Get-LSPasswordWithReason
Set-Alias LPCO Get-LSPasswordWithReason
Set-Alias LGCA Get-LSListOfCheckedOutAccounts
Set-Alias LSPCI Set-LSPasswordCheckIn
Set-Alias LPCI Set-LSPasswordCheckIn
Set-Alias LRQP Set-LSPasswordRequest
Set-Alias LGPR Get-LSListOfPasswordRequests
Set-Alias LDNR Deny-LSPasswordRequest
Set-Alias LGRR Grant-LSPasswordRequest
Set-Alias LGSA Get-LSListOfStoredAccountsForSystem
Set-Alias LSP Set-LSPassword
Set-Alias LSPS Set-LSPasswordSpin
Set-Alias LSPL Set-LSLocalPasswordInStore
Set-Alias LGPL Get-LSLocalPasswordFromStore
Set-Alias LGPT Get-LSLocalPasswordUTCSetTime
Set-Alias LGLA Get-LSListOfLocalAccounts
Set-Alias LPCOPL Get-LSPasswordCheckoutFromPasswordList
Set-Alias LGPCOPL Get-LSPasswordCheckoutFromPasswordList
Set-Alias LPCIPL Set-LSPasswordCheckinInPasswordList
Set-Alias LSPCIPL Set-LSPasswordCheckinInPasswordList
Set-Alias LSPPL Set-LSPasswordInPasswordList
Set-Alias LNPL New-LSRandomPasswordLocal
Set-Alias LNRP New-LSRandomPassword
Set-Alias LGF Get-LSFileFromStore
Set-Alias LSF Save-LSFileInStore
Set-Alias LSVF Save-LSFileInStore
Set-Alias LSHS Get-LSHostPowerStatus

Test-LSConnection

$loginToken = Get-LSLoginToken -Username trmye -Password Km613522^!#%@@
$password = Get-LSPasswordWithoutReason -AccountName $accountName -AuthenticationToken $loginToken -SystemName $systemName -Namespace $nameSpace
#return $password

$accountName = "cu612"
$systemName = "redmond.corp.microsoft.com"
$nameSpace = "redmond.corp.microsoft.com"
$loginToken

$password

get-help Get-LSLoginToken