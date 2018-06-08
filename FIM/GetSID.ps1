#----------------------------------------------------------------------------------------------------------
 set-variable -name URI -value "http://trmye2012r2vm:5725/resourcemanagementservice"     -option constant 
 set-variable -name DN -value "LDAP://CN=Travis Myers,OU=FIMObjects,DC=microsoft,DC=Com" -option constant 
#----------------------------------------------------------------------------------------------------------
 If(@(get-pssnapin | where-object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {add-pssnapin FIMAutomation}
#----------------------------------------------------------------------------------------------------------
 $AdUser = [ADSI]($DN)
 If($AdUser.objectGuid -eq $null) {Throw "Object not found in Active Directory"}
 $UserSid  = New-Object System.Security.Principal.SecurityIdentifier($AdUser.objectSid[0], 0)
 $Nt4Name  = $UserSid.Translate([System.Security.Principal.NTAccount])
 $Nt4Domain = ($Nt4Name.Value.Split("\"))[0]
 $Nt4Account = ($Nt4Name.Value.Split("\"))[1]
#----------------------------------------------------------------------------------------------------------
 Clear-Host
 Write-Host "User Data"
 Write-Host "========="
 $DataRecord = New-Object PSObject
 $DataRecord | Add-Member NoteProperty "DN" $DN
 $DataRecord | Add-Member NoteProperty "SamAccountName" ($Nt4Name.Value.Split("\"))[1]
 $DataRecord | Add-Member NoteProperty "Domain" ($Nt4Name.Value.Split("\"))[0]
 $DataRecord | Add-Member NoteProperty "SID" $($UserSid.ToString())
 $DataRecord | Format-List
#----------------------------------------------------------------------------------------------------------
 Trap 
 { 
  Write-Host "`nError: $($_.Exception.Message)`n" -foregroundcolor white -backgroundcolor darkred
  Exit 1
 }
#----------------------------------------------------------------------------------------------------------

Add-PSSnapin FIMAutomation