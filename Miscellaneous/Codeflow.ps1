## Find a codeflow project
\\codeflow\public\cfproj list -DisplayNameContains Office
## Template for creating a codeflow project
##\\codeflow\public\cfproj.cmd create -CodeFlowProject OneITVSO_Prvent_VSTSPS  -SourceControlProvider "SourceControlProvider=Git"  -DisplayName "Test VSO git" -codePublishFolder \\<Your File share>\ -owners biachary
\\codeflow\public\cfproj.cmd create -CodeFlowProject OneITVSO_Prvent_VSTSPS  -SourceControlProvider "SourceControlProvider=Git"  -DisplayName "Code Sling - Project VSTSPS" -codePublishFolder \\AZ-IAM-VM1511\Codeflow -owners redmond\trmye

## Update a project
\\codeflow\public\cfproj help update
\\codeflow\public\cfproj help addConfig

\\codeflow\public\cfproj update -SourceControlProvider "SourceControlProvider=GIT; Server=https://microsoftit.visualstudio.com/DefaultCollection/OneITVSO" -CodeFlowProject OneITVSO_Prvent_VSTSPS

http://CodeFlow/Services/DiscoveryService.svc

