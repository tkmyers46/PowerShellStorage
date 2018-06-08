
$Domain = "Redmond"
$AccountName = "v-udvuru"
$sidArray = [System.Convert]::FromBase64String("AQUAAAAAAAUVAAAA71I1JzEyxT2s9UYraQQAAA==") # This sid is a random value to allocate the byte array
$args = (,$Domain)
$args += $AccountName
$ntaccount = New-Object System.Security.Principal.NTAccount $args
$desiredSid = $ntaccount.Translate([System.Security.Principal.SecurityIdentifier])
write-host " -Account SID : ($Domain\$AccountName) $desiredSid"
$desiredSid.GetBinaryForm($sidArray,0)
$desiredSidString = [System.Convert]::ToBase64String($sidArray)
$desiredSidString

