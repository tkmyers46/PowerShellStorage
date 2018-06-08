ipmo D:\FIMSVC\Scripts\FimCmdlets.dll
if(@(get-pssnapin | where-object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {add-pssnapin FIMAutomation}
########################################################################################
#######Get ObjectSID from FIM (which is currently stored),show it in String SID#########
########################################################################################
$Domain = "Redmond"
$AccountName = "v-briahe"
$exportObject = $null;
$exportObject = export-fimconfig -uri $URI -onlyBaseResources -customconfig ("/Person[AccountName='$AccountName']")
if($exportObject -eq $null) 
{
$UserSid = "user not found in FIM"
throw "Cannot find an account by that name"
} 
 
$objectSID = $exportObject.ResourceManagementObject.ResourceManagementAttributes | Where-Object {$_.AttributeName -eq "ObjectSID"}
Write-Host " -FIM ObjectSID for ($Domain\$AccountName) : " $objectSID.Value 
$sidArray = [System.Convert]::FromBase64String($objectSID.Value)
$UserSid  = New-Object System.Security.Principal.SecurityIdentifier($sidArray, 0)
Write-Host " -FIM String SID for ($Domain\$AccountName) :" $UserSid

#######################################################
#######Get SID from AD ,show it in FIM ObJect SID######
#######################################################
$sidArray = [System.Convert]::FromBase64String("AQUAAAAAAAUVAAAA71I1JzEyxT2s9UYraQQAAA==") # This sid is a random value to allocate the byte array
$args = (,$Domain)
$args += $AccountName
$ntaccount = New-Object System.Security.Principal.NTAccount $args
$desiredSid = $null;
$desiredSid = $ntaccount.Translate([System.Security.Principal.SecurityIdentifier])
if($desiredSid -eq $null) #  To Do : handle exception if user is not found.
{
$desiredSid = "user not found in AD"
throw "Cannot find an account by that name in AD"
} 
write-host "-AD SID for ($Domain\$AccountName): " $desiredSid

$desiredSid.GetBinaryForm($sidArray,0)
$desiredSidString = [System.Convert]::ToBase64String($sidArray)
write-host " -AD ObjectSID for ($Domain\$AccountName): "$desiredSidString

