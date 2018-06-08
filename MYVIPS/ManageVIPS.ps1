 cd E:\drop\Share\Scripts\MYVIP\Invoke-WFLTMVIP.ps1
 
 $BASE_URI = 'https://atmmt'

 Invoke-WFLTMVIP -Activity GetALLVIPS
 Invoke-WFLTMVIP -Activity LTMDATACENTER
 
 # Area: OnPrem
 # NetworkType: CORP
 # DataCenter: CO1
 # VipName: PhoneregProd_443_vs
 # Pool: PhoneregProd_443_pl
#UserNote    : CO1-PHONEREG-UAT
#Name        : phoneRegUAT_443_vs
#Area        : OnPrem
#NetworkType : CORP
#DataCenter  : CO1
#SelfLink    : https://atmmt/api/v1.0/ltm/vip/phoneRegUAT_443_vs/OnPrem/CORP/CO1
#IpAddress   : 157.59.236.140:443

 Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName phoneRegUAT_443_vs
 Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CY1 -VipName corp_cy1phonreg_443_vs

 # !!Caution!! Production VIP, don't run delete unless you validate the IP address first
 Invoke-WFLTMVIP -Activity DELETEPOOLMEMBER -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName PhoneregProd_443_vs -PoolName PhoneregProd_443_pl -MemberName 10.220.181.75:443
 Invoke-WFLTMVIP -Activity DELETEPOOLMEMBER -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName PhoneregProd_443_vs -PoolName PhoneregProd_443_pl -MemberName 10.222.164.183:443

 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName PhoneregProd_443_vs -NodeName 10.220.181.96 -Body @" 
 {
 "Status": "Disabled"
 }
"@

 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName PhoneregProd_443_vs -NodeName 10.159.65.74 -Body @" 
 {
 "Status": "Enabled"
 }
"@

 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName PhoneregProd_443_vs -NodeName 10.144.132.197 -Body @" 
 {
 "Status": "Disabled"
 }
"@


 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CY1 -VipName corp_cy1phonreg_443_vs -NodeName 10.159.65.74 -Body @" 
 {
 "Status": "Enabled"
 }
"@

 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CY1 -VipName corp_cy1phonreg_443_vs -NodeName 10.144.132.197 -Body @" 
 {
 "Status": "Enabled"
 }
"@

 # Area: OnPrem
 # NetworkType: CORP
 # DataCenter: CO1
 # VipName: phoneRegUAT_443_vs
 # Pool: phoneRegUAT_443_pl

 Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName phoneRegUAT_443_vs

 Invoke-WFLTMVIP -Activity DELETEPOOLMEMBER -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName phoneRegUAT_443_vs -PoolName phoneRegUAT_443_pl -MemberName 10.159.65.74:443

 Invoke-WFLTMVIP -Activity UPDATENODE -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName phoneRegUAT_443_vs -NodeName 10.220.181.96 -Body @" 
 {
 "Status": "Enabled"
 }
"@

 # Area: OnPrem
 # NetworkType: CORP
 # DataCenter: CO1
 # VipName: sspmporta_443_vs
 # Pool: sspmporta_443_pl

 Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName sspmporta_443_vs

 Invoke-WFLTMVIP -Activity DELETEPOOLMEMBER -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName sspmporta_443_vs -PoolName sspmporta_443_pl -MemberName 10.220.181.68:443

 Invoke-WFLTMVIP -Activity CREATEPOOLMEMBER -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName sspmporta_443_vs -PoolName sspmporta_443_pl -Body @" 
 {
 "Address": "10.222.162.247",
 "Port": "443"
 }
"@