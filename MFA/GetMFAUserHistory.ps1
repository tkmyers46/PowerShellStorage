cd '\\co1dautil01\share\Scripts\PS\RemoteAccess\MFA' #Change to cloud folder for my scripts Get-MFAEvents_ro.ps1
cd 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\PS\DaveNewman\Scripts' #Get-NPSEvents_ro.ps1
cd 'C:\Users\trmye\OneDrive - Microsoft 1\Scripts\PS\NPS' #Get-NPSEvents.ps1
.\Get-MFAEvents_ro.ps1 -MfaServerGroup Americas -SearchQuery melvinf@microsoft.com
.\Get-MFAEvents_ro.ps1 -MfaServerGroup Americas -SearchQuery kturner@microsoft.com
.\Get-MFAEvents_ro.ps1 -Server co1-pfa-005 -SearchQuery kturner@microsoft.com -Verbose Americas -TimeStamp "2016-02-27 16:39:13"
.\Get-MFAEvents_ro.ps1 -Server co1-pfa-005 -SearchQuery kturner@microsoft.com
.\Get-MFAEvents_ro.ps1 -Server co1-pfa-005 -SearchQuery kturner@microsoft.com -Verbose Americas -TimeStamp "2016-02-27 16:39:13"
.\Get-MFAEvents_ro.ps1 -MFAServerGroup All -SearchQuery v-chtom@microsoft.com
.\Get-MFAEvents_ro.ps1 -MFAServerGroup All -SearchQuery a-xiwang@microsoft.com
.\Get-MFAEvents_ro.ps1 -MFAServerGroup All -SearchQuery tscholl@microsoft.com
.\Get-MFAEvents_ro.ps1 -MFAServerGroup All -SearchQuery anandku@microsoft.com
.\Get-MFAEvents_ro.ps1 -Server co1-pfa-005 -SearchQuery kturner@microsoft.com -TimeStamp "2016-02-27 16:39:13"
.\Get-NPSEvents_ro.ps1 -Server TK5-RADWR01 -SearchQuery kturner@microsoft.com
.\Get-NPSEvents_ro.ps1 -Server All -SearchQuery kturner@microsoft.com
.\Get-NPSEvents_ro.ps1 -Server All -SearchQuery kturner@microsoft.com -Verbose Americas
.\Get-NPSEvents_ro.ps1 -Server All -SearchQuery kturner@microsoft.com -OutputObject All
.\Get-NPSEvents_ro.ps1 -Server tk5-radwr01 -SearchQuery kturner@microsoft.com -TimeStamp "2016-02-27 16:39:13"
.\Get-NPSEvents_ro.ps1 -Server tk5-radwr01 -SearchQuery kturner@microsoft.com -TimeStamp "2016-02-27" -OutputObject Americas
.\Get-NPSEvents_ro.ps1 -Server All -SearchQuery kturner@microsoft.com -TimeStamp "2016-02-27 16:39:13" -OutputObject All
.\Get-NPSEvents_ro.ps1 -SearchQuery kturner@microsoft.com -TimeStamp "2016-02-27 16:39:13" -OutputObject Americas
.\Get-NPSEvents_ro.ps1 -NpsServerGroup All -SearchQuery kturner@microsoft.com
.\Get-NPSEvents.ps1 -Server all -SearchQuery kturner@microsoft.com