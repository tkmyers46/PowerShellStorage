# MYVIPS management
This is the Core Services Engineering [MYVIPS ATM](http://myvips/) management documentation for th e Self-Service Password Management portal infrastructure. [Managed by the Phone Reg Dev Team](#contact-our-team)

## Get started with Azure Traffic Management (MYVIP)
Go to the [MYVIPS ATM](http://myvips/) portal [FAQ](http://myvips/Home/Faq) page. There are [PowerShell](https://nisnetdocs/DocSources/public/ATM_POSH/index.html) and Rest API option. This document covers PowerShell VIP management.
##	Installation process
Run the script 'Invoke-WFLTMVIP.ps1'. Use the example script 'ManageVIPS.ps1'.
##	SSPM VIP configuration
 - **Area:**        OnPrem
 - **NetworkType:** CORP
 - **DataCenter:**  CO1
 - **VipName:**     sspmporta_443_vs
 - **Pool:**        sspmporta_443_pl
 * Note, The 'Monitor' setting option is custom. The setting 'sspmporta_443_monitor' allows the user to enable and disable a VIP member port by changing the name of a text file from 'active.txt' to 'inactive.txt' in the load balancer folder under the inet root directory.

# Network Load Balance
MYVIP allows the team to provide multiple network paths to the application. It also makes it possible to patch and update with as little downtime as possilbe. 
## SSPM VIP DIAGRAM (From [VISIO](./SSPMWebPortalNetworkDiagram.vsdx))
![VIP network diagram is under MYVIP folder SSPMWebPoratlNetworkDiagram.vsdx](./SSPMVIP.png =1000x550)


# Contact our team
- **Email** Phone Registration Dev Team: phoneregidev@microsoft.com
- **Microsoft Teams** [User & Entitlements Engineering](https://teams.microsoft.com/l/channel/19%3a055e03eba85b4e0a9706caeceac6b78f%40thread.skype/Phone%2520Registration?groupId=c126cd4f-154d-4ab5-85bd-e017c1460833&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47)
- **Yammer** [Identity and Access Management](https://www.yammer.com/microsoft.com/#/threads/inGroup?type=in_group&feedId=892258)

























PhoneRegiDev!!