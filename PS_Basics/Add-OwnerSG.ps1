$area = 'OnPrem'
$networktype = 'CORP'
$datacenter = 'CO1'

#UserNote    : CY1_PFA_PROD
#Name        : corp_CY1PFAPROD_443_vs
#Area        : OnPrem
#NetworkType : CORP
#DataCenter  : CY1
#SelfLink    : https://atmmt/api/v1.0/ltm/vip/corp_CY1PFAPROD_443_vs/OnPrem/CORP/CY1
#IpAddress   : 10.221.132.79:443
# Format https://atmmtuat/api/v1.0/ltm/vip/az_corp_TestVIP_80_vs/owner/az/corp/LabAA
# POST https://atmmt/api/v1.0/ltm/vip/corp_cy1sspm443_443_vs/owner/OnPrem/CORP/CY1

$resource = 'https://atmmt/api/v1.0/ltm/vip/corp_SSPMVIP_443_vs/owner/OnPrem/CORP/CY1'

$config = @"
"redmond\\sspm-vip-mgmt"
"@


#RUN
Invoke-RestMethod -Method POST -Uri $resource -Body ($config)  -ContentType "application/json" -UseDefaultCredentials -Verbose