
PARAM([parameter(Mandatory=$true,Position=0,HelpMessage=”Specify the User's DisplayName in FIM")] 
      [String] 
      $DisplayName,
      [parameter(Mandatory=$true,Position=1,HelpMessage=”Set a DateTime object")] 
      [DateTime] 
      $Date
     )

function Set-RegistrationDate
{
    PARAM($DisplayName, $Date)
    END
    {
        Write-Host ("Setting registration date of user {0} to {1}" -f $DisplayName,$Date)
        New-FimImportObject -ObjectType Person -State Put -AnchorPairs @{DisplayName=$DisplayName} -Changes @( New-FimImportChange -Operation Replace -AttributeName LastRegistrationDate -AttributeValue $Date) -ApplyNow
    }
}



New-FimImportObject -ObjectType Person -State Put -AnchorPairs @{DisplayName=$DisplayName} -Changes @( New-FimImportChange -Operation Replace -AttributeName LastRegistrationDate -AttributeValue $Date) -ApplyNow