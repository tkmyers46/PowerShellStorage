Use-CacheCluster -Provider System.Data.SqlClient -ConnectionString "Data Source=TRMYE2012R2VM;Initial Catalog=PhoneReggieCache;Integrated Security=True"
Grant-CacheAllowedClientAccount -Account "redmond\devpfweb" TR
#The next command should show the above account added to the allowed client list
Get-CacheAllowedClientAccounts
#The next command, start cache cluster, should say UP
Start-CacheCluster
#After it is running, execute these commands
Get-Command -Module DistributedCacheAdministration
Remove-Cache -CacheName default
New-Cache -CacheName default -TimeToLive 4320 -NotificationsEnabled True