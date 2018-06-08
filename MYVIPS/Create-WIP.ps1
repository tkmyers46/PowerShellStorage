#-------------------------------------------------------------------------------------------
#
#Sample that creates  a new WIP. Depending on VIP datacenter, it may create multiple pools
#
#------------------------------------------------------------------------------------------

#Path to the UAT API
$resource = "https://atmmt/api/v1.0/gtm/wip/corp"

#JSON Config
$config =  @"
{    
    'fqdn':'phoneregistration.gtm.corp.microsoft.com',
    'description':'Wide ip created from API',
    'TTLPersistence':300,
    'PoolLbMode':'global-availability',
    
    'vip' : [{'ipaddress':'10.221.132.91', 'port':'443'},
             {'ipaddress':'157.59.210.164', 'port':'443'}    
            ],
    'metadata':{'OwnerAlias' :'trmye', 
                'BusinessJustification' : 'global load balance sspm portal',
                'OwnerSecurityGroup' :['redmond\\iammfaeng', 'redmond\\phoneregidev']
                }
}
"@


#RUN
Invoke-RestMethod -Method Post  -Uri $resource -Body ($config)  -ContentType "application/json" -UseDefaultCredentials