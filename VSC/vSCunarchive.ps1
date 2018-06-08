###
### Unarchive old vSCs
###
$test= (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft IT\vSC_BlockArchive')

function vScUnarchive{

   
    $Store = Get-Item cert:\CurrentUser\My
    $Store.Open('ReadWrite,IncludeArchived')

    # Get all vSC certs, certweb/fim-cm/ngc
    $AllvScCerts = $Store.Certificates |
        where { $_.Extensions |
            where {  ( $_.Oid.Value -match    '2.5.29.32'               ) -and ` # with issuance policy that is
                    (( $_.Format(0) -match    'msit-vsmartcard-logon'   ) -or  ` # msit-vsmartcard-logon
                     ( $_.Format(0) -match    '1.3.6.1.4.1.311.42.1.5'  )) }} 


    # Get all non-NGC certs
    $NonNgcCerts = $AllvScCerts |
        where { $_.Extensions |
            where {  ( $_.Oid.Value -match    '2.5.29.32'               ) -and ` # with issuance policy that is
                    (( $_.Format(0) -notmatch 'msit-vsmartcard-intune'  ) -and ` # not an NGC cert
                     ( $_.Format(0) -notmatch '1.3.6.1.4.1.311.42.1.20' )) }} 

    # restore disabled vSC devices
    Get-PnpDevice | 
        where { ( $_.FriendlyName -match "Virtual Smartcard") –or `
                ( $_.FriendlyName -match "FIM CM Virtual Smart card") } | 
            Enable-PnpDevice -Confirm:$false

    # unarchive all non-NGC certs
    foreach ($NonNgcCert in $NonNgcCerts)
    {
        $NonNgcCert
        Write-Host "Found Certs to unarchive."
        $NonNgcCert.Archived = $false
    }

    $Store.Close()
}

If ($test)
{
        Write-Host "Registry Key already exists, but will attempt to unarchive vSmart Card."
        vScUnarchive
} 
else 
{
        New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft IT\' -Name vSC_BlockArchive 
        vScUnarchive
}


