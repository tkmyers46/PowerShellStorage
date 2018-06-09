##############################
### SECURE ADMIN SERVICES ####
### ADMIN DATA COLLECTION ####
##############################

##############################
# Revision
#
# 1.0.0.0 - (01/01/0000) # Prevision Production Release
# 1.0.0.1 - (01/26/2017) # Added new Windows Service for AdminAudit (Filter CY1B)
# 1.0.0.2 - (01/31/2017) # minor tweak for cert import (support for PoSH 2.0)
#
##############################


# Collect System Information
    $CN = $env:computerName
    $ServerName = ([System.Net.Dns]::GetHostByName(($CN))).HostName
    $servernamefqdn = $servername
    $servernamefqdnquote = '"' + $servernamefqdn + '"'
	$outputPath = "\\filesharepath\" + $servernamefqdn + ".gpo"   
	$secondOutputPath = "\\filesharepath\"

#Execute Data Collection (via Omniscient)
    $cmd = "\\filesharepath\Omniscient.exe -T=" + $servernamefqdnquote + " -sd --tsv=" + $outputPath   
    invoke-expression $cmd
	$fullPath = $outputPath + "_groups.tsv"
	copy-item $fullPath $secondOutputPath


    $asset = Get-WmiObject Win32_SystemEnclosure
    $serial = $asset.SerialNumber
    $asset = $asset.SMBIOSAssetTag
    $filecontents = @()
    $filecontents = '<?xml version="1.0"?>'
    $filecontents += '<sysinfo xmlns="http://schemas.microsoft.com/powershell/2004/04" Version="1.1.0.1">'
    $server = $servername.split(".")
    $serveradobject = get-adcomputer $server[0] -server $server[1] -Properties *
    $serverdistinguishedname = $serveradobject.distinguishedname
    $serverobjectguid = $serveradobject.objectguid
    $serverobjectsid = $serveradobject.sid
    $serverobjectenabled = $serveradobject.enabled
    $servercanonicalname = $serveradobject.canonicalname
    $machineline = "<machine name=" + '"' + $server[0] + '"' + " fqdn=" + '"' + $servernamefqdn + '"' + " serverdistinguishedname=" + '"' + $serverdistinguishedname + '"' + " serverobjectguid=" + '"' + $serverobjectguid + '"' + " servercanonicalname=" + '"' + $servercanonicalname + '"' + " serverobjectsid=" + '"' + $serverobjectsid + '"' + "/>"
    $filecontents += $machineline
    $serialline = "<serial number=" + '"' + $serial.trim() + '"' + " />"
    $filecontents += $serialline
    $assetline = "<asset number=" + '"' + $asset.trim() + '"' + " />"
    $filecontents += $assetline
    $filecontents += '</sysinfo>'
    $assetfilepath = "\\servername\fileshare\" + $servernamefqdn + ".xml"
    $filecontents | out-file $assetfilepath


    
    $taskxmlpath = "\\servername\fileshare\AdminAudit.XML"
    $taskxmlcontents = get-content $taskxmlpath | Out-String
    [xml]$taskxml = get-content $taskxmlpath
    $taskname = "AdminAudit"

    $currenttask = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
    if ($currenttask){ 
        write-host "Task Already Exists: " $currenttask

    
            if (!($taskxml.task.triggers.eventtrigger.subscription -eq $currenttask.triggers.subscription)){
            write-host "not equal"
            Unregister-ScheduledTask -TaskName $taskname -confirm $false
            Register-ScheduledTask -taskname $taskname -Xml $taskxmlcontents
            exit
            }
                else {
                write-host "equal"
                }


            if (!($taskxml.task.actions.exec.arguments -eq $currenttask.actions.arguments)){
            write-host "not equal"
            try{
                invoke-expression "schtasks /delete /tn $taskname /f"
                }
                catch
                {
                write-host "Failure"
                }
            Register-ScheduledTask -taskname $taskname -Xml $taskxmlcontents
            exit
            }
                else {
                write-host "equal"
                }


    
    }else{
     Register-ScheduledTask -taskname $taskname -Xml $taskxmlcontents
     }


Invoke-Expression "powershell.exe -executionpolicy bypass -file '\\servername\fileshare\register-SAWEnforceNotifier.ps1'"

$p7b = '\\servername\fileshare\certificatename.p7b'
try
{
    Import-Certificate2 -FilePath $p7b -CertStoreLocation Cert:\LocalMachine\Root
}
catch
{
    certutil -addstore "Root" "$p7b"
}

if ($env:computerName)
{
    write-host "ServerName matches scope, installing service"

    $service = get-service sasauditservice -ErrorAction SilentlyContinue
    if (!($service) -or $service.status -eq "Stopped")
    {
    write-host "   Installing"
    $install = 'msiexec /i "\\\Microsoft.SAS.Audit.ClientService.Installer.msi" /quiet'
    invoke-expression $install

    start-sleep 15
    Start-Service sasauditservice
    }
}


# Execution ACLXRay Data Collection
    
md c:\AdminAudit
push-location c:\adminaudit
copy-item  \\redmond\saw\scratch\adminscripts\aclxray\aclxrayclient\*.* c:\adminaudit\ -Filter *.* -force

cscript c:\adminaudit\ACLXRAYClient.WSF /GetFiles /GetFolders /GetShares /GetServices /GetScheduledTasks /GetProfiles /GetLocalGroups /GetDCOM /GetUserRights /SupressDetail /FilterInherited /WriteIndex

copy-item c:\adminaudit\*.csv \\redmond\saw\scratch\adminscripts\aclxray\logs -force
pop-location
del c:\adminaudit\*.* -Recurse
rd c:\adminaudit -Recurse -force


