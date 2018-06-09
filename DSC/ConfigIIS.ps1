# This basic Desired State Configuration is for a basic web server with ASP.NET 4.5 installed. 
# Run this script, if there are no errors, you should have a folder named IISWebsite
# If ConfigIISEnvData is correct, you should have two MOF files named server1 and server2
# Run the command Start-DscConfiguration -Path ConfigIIS -Wait -Verbose
# This will apply the configuration for any server with a MOF file in the folder ConfigIIS
# Optionally, you can add the parameter -ComputerName server1 to apply the config to only
# the specified server ex. Start-DscConfiguration -ComputerName server1 -Path ConfigIIS -Wait -Verbose

# Find-DscResource

Configuration IISWebsite
{

# Import required resource for this configuration script (Must be run in the block!)
Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    # For all the nodes in the ConfigIISEnvData.psd1 where they have 'webserver'
    # Install these WindowsFeatures
    Node $AllNodes.Where{$_.Role -contains "WebServer"}.Nodename
    {
        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }

        # Run Get-WindowsFeature on a windows server
        # You should see a long list of features with readable names
        # In the second column of that list, the feature short names
        # match these ex. Name = "Web-Asp-Net45"
        WindowsFeature ASP
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }
    }

    # These blocks retrieve variables from the ConfigIISEnvData.psd1 file
    # For the Node tagged as Production, add the account to local admin on the server
    Node $AllNodes.Where{$_.Role -contains "Production"}.Nodename
    {
        Group AddToAdmin
        {
            GroupName = "Administrators"
            Ensure="Present"
            MembersToInclude = $ConfigurationData.NonNodeData.Administrators
        }
    }
}
# Close out your DSC configuration block, the parameter following is points to a configuration file
# The configuration file has to be in the same directory as the script, or provide a relative path
IISWebSite -ConfigurationData ConfigIISEnvData.psd1