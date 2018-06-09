# Package Sources and Management
Get-PackageProvider -ListAvailable

# PowerShellGet and Nuget
Install-PackageProvider -Name Nuget -Verbose

# PowerShellGet and PackageManagement v5.0 only
Install-PackageProvider -Name PowerShellGet -Verbose

# GistProvider
Install-PackageProvider -Name "Gistprovider" -Verbose

# Find new modules, use wildcards if you don't know the name
Find-Module -Name xW*
Find-Module *web*
