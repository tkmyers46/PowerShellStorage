
$GroupToExpand = '<replacewithadsggroup>'
$error.clear()
Import-Module E:\drop\Share\MS.IT.PhoneAuth.PFClient.dll

#region Phone Factor Agent (PFA) objects     

    #What type of service calls PFA, sdk, adfs, radius...
    $authtype = New-Object MS.IT.PhoneAuth.PFClient.pfwssdk.AuthenticationType

    #Auth types are enums, #8 is pfsdk
    $authtype.value__ = 8

    #Same as C#, instead of object 'out' use reference in powershell [ref]
    [ref]$callresult = New-Object MS.IT.PhoneAuth.PFClient.pfwssdk.CallResult
    [ref]$pfwError = New-Object MS.IT.PhoneAuth.PFClient.pfwssdk.Error
    [ref]$userSettings = New-Object MS.IT.PhoneAuth.PFClient.pfwssdk.UserSettings

#endregion

#region PfClient

    $sdkClientCert = Get-Item Cert:\LocalMachine\my\<thumbprint>

    $pfwsdkUrl = "https://<mfaendpoint>/multifactorauthwebservicesdk/PfWsSdk.asmx"

    $pfwssdk = New-Object MS.IT.PhoneAuth.PFClient.pfwssdk.PfWsSdk

    $pfwssdk.Url = $pfwsdkUrl

    $pfwssdk.ClientCertificates.Add($sdkClientCert)

#endregion
        
        #arrays for reports
        $pfaresults = @()
        $errors = @()

# Add or remove pipe for group, >3700 users. To test, uncomment Select-Object
$users = Get-ADGroup -Identity $GroupToExpand -Properties Members | Select-Object -ExpandProperty Members #| Select-Object -First 40

foreach ($user in $users) {

    try {

        $ext = Get-ADUser -Identity $user -Properties UserPrincipalName -Server adserver.domain.com:3268        
        
    }
    catch {

        $Errors += $user
        $_ | FL * -Force

    }

    try {
            
        $userfound = $pfwssdk.GetUserSettings($ext.UserPrincipalName, $userSettings, $pfwError)

        if ($userSettings.Value.Enabled) {
            #*** Warning ***
            #uncomment/comment disable statement to execute in prod. Add '$result = $true' to test
            $result = $pfwssdk.Disable($ext.UserPrincipalName, $ext.UserPrincipalName, $pfwError)            

            if ($result) {

                $comment = 'Disable succeeded'

            } else {

                $comment = 'Failed to disable'

            }

        } else {
            
            if (!$userfound) {

                $comment = 'No action taken'

            }                           
        }

                    $report = [PSCustomObject]@{ 'UserPrincipalName'   = $($ext.UserPrincipalName);
                                                 'DisabledInPfa'       = $($userSettings.Value.Enabled);
                                                 'PfwsSdkError'        = $($pfwError.Value.Description);
                                                 'Comment'             = $($comment);
                                               }
    }
    catch {

        $errors += $pfwError
        $_ | FL * -Force
    }

    $pfaresults += $report
    $_ | FL * -Force

}

#region Create Reports

    $localpatherrors = 'E:\Scripts\errors.csv'
    $localpathpfaresults = 'E:\Scripts\mfaresults.csv'

    $pfaresults | Select-Object UserPrincipalName, DisabledInPfa, PfwsSdkError, Comment | Export-Csv -Path $localpathpfaresults -NoTypeInformation
    $errors | Export-Csv -Path $localpatherrors -NoTypeInformation

    notepad $localpathpfaresults

#endregion    
