# Use ServerManger to add and remove features ***Remote Server Admin Tools***

# Get Installed + Available Server features
Get-WindowsFeature -ComputerName usw2-trmydev-01

# [X] 'installed [ ] 'not installed but available'
# Some features may not be available if they are not
# Included on the original WIM or server image
# Find available features on a VHD
Get-WindowsFeature -Vhd <# path to image #>

# Install a windows feature on a server using an alternate source
Install-WindowsFeature -Source <# path to image, VHD or server install directory #> -ComputerName usw2-trmydev-01

# Install a windows feature, by default installs any dependency features
# (Add the -WhatIf switch to see what is included without installation)
Install-WindowsFeature -Name XPS-Viewer -ComputerName usw2-trmydev-01 -WhatIf

# Install a windows feature, install all submodules in that feature
Install-WindowsFeature -Name Web-Ftp-Server -ComputerName usw2-trmydev-01 -IncludeAllSubFeature -WhatIf

# What if we install a subFeature? Does it require installation of something else?
Install-WindowsFeature -Name Web-Ftp-Service -ComputerName usw2-trmydev-01 -IncludeAllSubFeature -WhatIf
