﻿IF ((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections -ne "0") {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -trmye_TestServer "fDenyTSConnections" -Value 0}
Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -Enabled True
Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'