@{
    AllNodes = @(
        @{
            NodeName        = "server1"
            Role            = "WebServer","Production"            
        },

        @{
            NodeName        = "server2"
            Role            = "WebServer","Pre-Production"            
        }
    );

    NonNodeData = @{
        Administrators = @("domain\administrator1", domain\administrator2)
    }
}
