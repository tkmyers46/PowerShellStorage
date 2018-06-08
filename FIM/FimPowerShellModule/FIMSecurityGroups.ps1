Function GroupLookup ($group_objSID)
{
$group_temp = new-object system.security.principal.securityidentifier($group_objSID,0)
$group_SID = New-Object System.Security.Principal.SecurityIdentifier $group_temp.value
$group_GroupName = $group_SID.Translate( [System.Security.Principal.NTAccount])
$dName = $group_GroupName.value.SubString(0,($group_GroupName.Value.IndexOf("\")))
$cName = $group_GroupName.Value.SubString($group_GroupName.Value.IndexOf("\") + 1)
   if ((Get-WMIObject -Class Win32_ComputerSystem).Name -eq $dName)
   # this is a local group
   { 
   "local group " + $dName + "\" + $cName
   }
   else
   # this is domain group
   {
   $root = [ADSI]''
   $searcher = new-object System.DirectoryServices.DirectorySearcher($root)
   $searcher.filter = "(&(objectClass=group)(CN=$cName))"
   $adfind = $searcher.findone()
   $DN = $adfind.path
   "domain group " + $DN.SubString(7)
   }
}
$FIMSyncDBServer = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\services\FIMSynchronizationService\Parameters -name Server | select-object Server | format-table -hidetableheaders | where {$_ -ne ""} | Out-String -stream | select-object -skip 1
$SQLServer = $FIMSyncDBServer[0]

$FIMSyncDBName = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\services\FIMSynchronizationService\Parameters -name DBName | select-object DBName | format-table -hidetableheaders | where {$_ -ne ""} | Out-String -stream | select-object -skip 1
$SQLDBName = $FIMSyncDBName[0]

$FIMSyncSQLInstance = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\services\FIMSynchronizationService\Parameters -name SQLInstance | select-object SQLInstance | format-table -hidetableheaders | where {$_ -ne ""} | Out-String -stream | select-object -skip 1
$SQLInstance = $FIMSyncSQLInstance[0]

$SQLServer = $SQLServer.tostring().trim()
$SQLDBName = $SQLDBName.tostring().trim()
$SQLInstance = $SQLInstance.tostring().trim()

if (($SQLServer -eq "") -or ($SQLServer -eq $null))
{$SQLServer = "trmye2012r2vm"} else {$SQLServer = $SQLServer}

if (($SQLInstance -eq "") -or ($SQLInstance -eq $null))
{$SQLInstance = $null} else {$SQLServer = "$SQLServer\$SQLInstance"}

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "server=$SQLServer;database=$SQLDBName;Integrated Security=sspi"
$conn.Open()

$sql = "SELECT * FROM [" + $SQLDBName + "].[dbo].[mms_server_configuration]"
$cmd = New-Object System.Data.SqlClient.SqlCommand($sql,$conn)
$rdr = $cmd.ExecuteReader()
while($rdr.Read())
{
    $groupa_objSID = $rdr["administrators_sid"]
    $groupo_objSID = $rdr["operators_sid"]
    $groupj_objSID = $rdr["account_joiners_sid"]
    $groupb_objSID = $rdr["browse_sid"]
    $groupp_objSID = $rdr["passwordset_sid"]
}

$FIMSyncAdmins = GroupLookup $groupa_objSID
$FIMSyncOperators = GroupLookup $groupo_objSID
$FIMSyncJoiners = GroupLookup $groupj_objSID
$FIMSyncBrowse = GroupLookup $groupb_objSID
$FIMSyncPasswordSet = GroupLookup $groupp_objSID

"FIMSyncAdmins group is " + $FIMSyncAdmins
"FIMSyncOperators group is " + $FIMSyncOperators
"FIMSyncJoiners group is " + $FIMSyncJoiners
"FIMSyncBrowse group is "+ $FIMSyncBrowse
"FIMSyncPasswordSet group is " + $FIMSyncPasswordSet 