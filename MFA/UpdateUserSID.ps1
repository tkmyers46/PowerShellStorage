### Created: 2015-09-29
### Last updated: 2015-09-29 (alexale)
### This script will run UpdateUserSid-v3.exe againts the full PFA database on this server and 
### search all accounts for missing SID, then will attempt to update the missing SID by querying AD for it
### It will create a log file for each run. 
### If it finds at least one account with missing SID, will email the log to a designated below alias
###


$TimeStamp = get-date -Format yyyyMMddTHHmm
get-date >> d:\scripts\UpdateUserSidLog-$TimeStamp.txt
& 'C:\Program Files\Multi-Factor Authentication Server\UpdateUserSid-v3.exe' >> d:\scripts\UpdateUserSidLog-$TimeStamp.txt


$logfile = Get-Content d:\scripts\UpdateUserSidLog-$TimeStamp.txt

if ($logfile -match "1 updated")
    {
        [string]$logfileInHTML = $logfile |Out-String
        $logfileInHTML = $logfileInHTML -replace  ("`n", "<br>`n")

        $messagesubject = "Alert: PFA user account SID update successful"
        $messagebody = "
        <html>
        <body>
        <font color=Green>Found MFA account with missing SID and successfully populated the missing SID value</font>
        <br><font color=Green>No Action is required. This automated email is for awareness only</font>
        <br><br>The PFA (Phone Factor Authentication) database had at least one new PFA account with missing ObjectSID.
        <br>ObjectSID in PFA must be present and match the ObjectSID in AD or the user will be unable to use Phone Factor Authentication.
        <br>
        <br>Use the log information below for the alias(s) of accounts which SID was populated by this script.
        <br>
        <br>$logfileInHTML
        <br><br><i><font size=2>This email is automatically generated and sent from non-monitored email address.</i></font>
        <br><i><font size=2>Executed via scheduled task from $($env:COMPUTERNAME).redmond.corp.microsoft.com.</i></font>
        <br><i><font size=2 color=gray>For more information regarding this report, or if you think it should be modified, contact redmond\alexale.</i></font>
        </body>
        </html>

        "#end message body

        Send-MailMessage -Body $messagebody -To iampaalerts@microsoft.com -From pffimsvc@microsoft.com -SmtpServer smtphost.redmond.corp.microsoft.com -Subject $messagesubject -BodyAsHtml
}
elseif($logfile -match "1 failed")
        {
        [string]$logfileInHTML = $logfile |Out-String
        $logfileInHTML = $logfileInHTML -replace  ("`n", "<br>`n")

        $messagesubject = "Alert: PFA user account SID update failed"
        $messagebody = "
        <html>
        <body>
        <font color=Red>Found MFA account with missing SID and failed to update the missing SID with the correct attribute from Active Directory</font>
        <br><font color=Red>Action is required. Logon to the MFA server and fix the failed account.</font>
        <br><br>The PFA (Phone Factor Authentication) database had at least one new PFA account with missing ObjectSID.
        <br>ObjectSID in PFA must be present and match the ObjectSID in AD or the user will be unable to use Phone Factor Authentication.
        <br>
        <br>Use the log information below for the alias(s) of accounts which SID is missing and faield to update by this script.
        <br>
        <br>$logfileInHTML
        <br><br><i><font size=2>This email is automatically generated and sent from non-monitored email address.</i></font>
        <br><i><font size=2>Executed via scheduled task from $($env:COMPUTERNAME).redmond.corp.microsoft.com.</i></font>
        <br><i><font size=2 color=gray>For more information regarding this report, or if you think it should be modified, contact redmond\alexale.</i></font>
        </body>
        </html>

        "#end message body

        Send-MailMessage -Body $messagebody -To iampaalerts@microsoft.com -From pffimsvc@microsoft.com -SmtpServer smtphost.redmond.corp.microsoft.com -Subject $messagesubject -BodyAsHtml
     }

