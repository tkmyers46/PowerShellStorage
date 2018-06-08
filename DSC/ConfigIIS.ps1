# This basic state configuration file describes the desire to have a basic web server with ASP.NET 4.5 installed. 
# The output of this configuration statement is a MOF file for the server trmye2012r2vm, in a folder named IISWebSite.

# Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

# Find-DscResource

Configuration IISWebsite
{

# Import required resource for this configuration script (Must be run in the block!)
Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    Node trmye2012r2vm
    {

        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }

        WindowsFeature ASP
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }

    }
}

IISWebSite