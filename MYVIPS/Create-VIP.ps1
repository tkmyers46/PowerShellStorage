$area = 'OnPrem'
$networktype = 'CORP'
$datacenter = 'CY1'

Invoke-WFLTMVIP -Activity CREATEVIP -Area $area -NetworkType $networktype -DataCenter $datacenter -Body @"
    {
    'Name':  'cy1phonreg',
    'Description':  'cy1phonreg',
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
                        'Description':  'cy1phonreg',
                        'LoadBalancingMode':  'round-robin',
                        'Members' : [ {'address': '10.144.132.197', 'port':443 },{'address': '10.159.65.74', 'port':443 } ],
                        'Monitor' : 'http'
                        }

} 
"@
