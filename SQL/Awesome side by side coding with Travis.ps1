
$localpath = 'E:\Scripts\example.csv'
$GroupToExpand = 'CSS_2FA_Restricted'



Function Get-FQDNFromDN {
    [cmdletbinding()] Param (
    [Parameter (Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)] $DN
    )

    $fqdn = ''
    ForEach ( $item in $DN.Split(",") ) {
        if ($item.StartsWith("DC=")) { 
            Write-Verbose $item.Replace("DC=", ".")
            $fqdn += $item.Replace("DC=", ".") 
        }
    }
    $fqdn = $fqdn.Substring(1, $fqdn.Length-1)
    return $fqdn
}

$users=Get-ADGroup -Identity $GroupToExpand -Properties Members | Select-Object -First 10 -ExpandProperty Members

$domainaliaslist = @()
$errors = @()

ForEach ($user in $($users | Select-Object -First 10)) {
    Try {
        Write-Output "Querying: $user"
        $ext = Get-ADUser -Identity $user -Properties DistinguishedName, SAMAccountName, UserPrincipalName -Server corp.microsoft.com:3268

        $domainalias = [PSCustomObject]@{ 'Domain'              = $($(Get-FQDNFromDN -DN $ext.DistinguishedName).Split('.')[0]);
                                          'SAMAccountName'      = $($ext.SamAccountName);
                                        }
        $domainaliaslist += $domainalias
    } Catch {
        $Errors += $user
        $_ | FL * -Force
    }
}

$domainaliaslist | Select-Object Domain, SamAccountName | Export-Csv -Path $localPath -NoTypeInformation

notepad $localpath

$obj=Import-Csv $localPath
$obj[0].Domain
$obj[0].SAMAccountName