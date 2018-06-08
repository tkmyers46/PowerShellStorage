$area = 'OnPrem'
$networktype = 'CORP'
$datacenter = 'CY1'

#UserNote    : CY1_PFA_PROD
#Name        : corp_CY1PFAPROD_443_vs
#Area        : OnPrem
#NetworkType : CORP
#DataCenter  : CY1
#SelfLink    : https://atmmt/api/v1.0/ltm/vip/corp_CY1PFAPROD_443_vs/OnPrem/CORP/CY1
#IpAddress   : 10.221.132.79:443

Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CO1 -VipName sspmporta_443_vs

Invoke-WFLTMVIP -Activity GETVIP -Area OnPrem -NetworkType CORP -DataCenter CY1 -VipName corp_cy1sspm443_443_vs

Invoke-WFLTMVIP -Activity UPDATEVIP -Area $area -NetworkType $networktype -DataCenter $datacenter -VipName corp_cy1sspm443_443_vs -Body @"
{
    'Name':  'cy1sspm443',
    'Description':  'cy1sspm443',
    'Port': '443',
    'IpProtocol' :  'tcp',
    
    'Profiles' :[{'name' : 'fastL4'}],
    
    'Persist' : [{'Name' : 'msit_source_addr'}],

    'MetaData' : {
                  'BusinessJustification':'geo-load balanced website', 
                  'OwnerAlias':'trmye', 
                  
    'OwnerSecurityGroup' :['redmond\\iammfaeng', 'redmond\\phoneregidev']
                  },

    'PoolDetail' :    {                                                
                        'Description':  'cy1_sspm_443_pl',
                        'LoadBalancingMode':  'round-robin',
                        'Members' : [ {'address': '10.222.162.234', 'port':443 },{'address': '10.222.162.247', 'port':443 } ],
                        'Monitor' : 'https'
                        }

} 
"@

 Invoke-WFLTMVIP -Activity UPDATEPOOL -Area $area -NetworkType $networktype -DataCenter $datacenter -VipName corp_cy1sspm443_443_vs -PoolName corp_cy1sspm443_443_pl -Body @" 
{
 'Monitor':'https'
}
"@

 Invoke-WFLTMVIP -Activity UPDATEPOOL -Area $area -NetworkType $networktype -DataCenter $datacenter -VipName corp_cy1phonreg_443_vs -PoolName corp_cy1phonreg_443_pl -Body @" 
{
 'Monitor':'https'
}
"@
