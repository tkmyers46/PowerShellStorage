$wmi = Get-WmiObject -Class Win32_NetworkAdapter -filter "name LIKE '%wireless%'"

if ($wmi.NetEnabled -eq "True") { $wmi.disable() }
elseif ($wmi.NetEnabled -eq "False") { $wmi.enable() }
