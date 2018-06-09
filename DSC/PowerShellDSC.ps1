# Discover available DSC resources
# Position your typing cursor inside of the Node block and press CTRL+SPACE to see a list of DSC resources available inside of the Configuration block.

Configuration IISWebsite
{
    Node trmye2012r2vm
    {

    }
}

# Alternate method use the commandlet
Get-DscResource

# Find available modules, if prompted to install NuGet, select yes.
# This should return a list of modules available from PowerShell Gallery
Find-Module

# This lists all powershellgallery.com for DSC
Find-DscResource

# Install a module
Install-Module -Name xWebAdministration # Manage a website in IIS

# Check the target node for the desired installed features
Get-WindowsFeature -ComputerName servername -Name Web-Server, Web-ASP*

# Apply the desired state which will assert IIS and ASP.NET 4.5 are installed
Start-DscConfiguration -ComputerName servername -Path ConfigIIS -Wait -Verbose

Get-Module

Install-Module -Name PSDesiredStateConfiguration