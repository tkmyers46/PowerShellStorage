# Modules and their commands
Get-Module -ListAvailable
Get-Command -Module Microsoft.Powershell.Security

# Parameters
Test-Path -Path C:\Users\trmye\Documents\Scripts\PS_Demo

# Get-Help for any command that is supported in PowerShell
help dir
Get-Help dir
Get-Help dir -Detailed
Get-Help dir -Examples
Get-Help Test-Path -Detailed

Get-Help Write-Host -Examples
write-host (2,4,6,8,10,12) -Separator ", -> " -foregroundcolor DarkGreen -backgroundcolor white
