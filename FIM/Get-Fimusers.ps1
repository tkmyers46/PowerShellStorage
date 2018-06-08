add-pssnapin fimautomation -ErrorAction SilentlyContinue
import-module c:\phoneregistration\FimPowerShellModule.psm1

$user = Get-Credential
$people = Export-FIMConfig -CustomConfig "/Person" -uri http://co1-pfs-001:5725 -credential $user 
# -OnlyBaseResources
$people | ConvertFrom-FIMResource -file c:\temp\fim\people-pilot.xml
$pspeople = ($people | Convert-FimExportToPSObject )
$pspeople | Out-GridView


## http://co1-pfs-001:5725/ResourceManagementService/Resource
