function Invoke-WindowsUpdate
{
    <#
    .EXTERNALHELP KBWindowsUpdate-Help.xml
    #>
    [CmdletBinding(
    DefaultParameterSetName='Install',
    SupportsShouldProcess=$True,
    ConfirmImpact='High')]

    PARAM(

        [Parameter(ParameterSetName='Install')]
        [switch]
        $Force,

        [Parameter(ParameterSetName='Install')]
        [switch]
        $Reboot,

        [Parameter(ParameterSetName='DownloadOnly')]
        [switch]
        $DownloadOnly

    )

    Begin
    {
        #Check for pending reboot status
        $RebootRequired = (New-Object -ComObject "Microsoft.Update.SystemInfo").rebootrequired

        #Admin Rights Check
        $user = [Security.Principal.WindowsIdentity]::GetCurrent()
        $isAdmin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        if(!$isAdmin){Write-Warning "PHASE 0 (PRE-CHECKS): Cmdlet is not being run with Administrative Priveledges.`n`t`t If the cmdlet does not function as expected, try running with Administrative Rights"}

        #Check if reboot is pending and if parameter set is NOT DownloadOnly
        if($RebootRequired -and !$DownloadOnly)
        {
            Write-Warning "PHASE 0 (PRE-CHECKS): A reboot is currently pending.`n`t`t If the -Force parameter is not set, updates will only be downloaded"

            #Check for -Force switch parameter
            if($Force)
            {
                Write-Verbose "PHASE 0 (PRE-CHECKS): -Force parameter is set.`n`t`t Update installs will be attempted"
            }
            else
            {
                Write-Warning "PHASE 0 (PRE-CHECKS): -Force parameter is NOT set.`n`t`t Updates will only be downloaded"
                $DownloadOnly = $True
            }
        }

        #Create Windows Update Session, Searcher, Downloader, and Installer Com Objects
        $WUSession = new-object -ComObject Microsoft.Update.Session
        $WUSearcher = $WUSession.CreateUpdateSearcher()
        $WUDownloader = $WUSession.CreateUpdateDownloader() #Bug doesn't allow this to be run remotely
        $WUInstaller = $WUSession.CreateUpdateInstaller() #Bug doesn't allow this to be run remotely
        $WUUpdateCollection = New-Object -ComObject Microsoft.Update.UpdateColl

        $Return = New-Object PSObject -Property @{
            AttemptedDownloads = New-Object -ComObject Microsoft.Update.UpdateColl
            AttemptedInstalls = New-Object -ComObject Microsoft.Update.UpdateColl
            SuccessfulDownloads = New-Object -ComObject Microsoft.Update.UpdateColl
            SuccessfulInstalls = New-Object -ComObject Microsoft.Update.UpdateColl
            UnsuccessfulDownloads = New-Object -ComObject Microsoft.Update.UpdateColl
            UnsuccessfulInstalls = New-Object -ComObject Microsoft.Update.UpdateColl
        }
        
        if(!(Get-TypeData ResultCode))
        {
            Add-Type -TypeDefinition @"
            public enum ResultCode
            {
               NotStarted = 0,
               InProgress = 1,
               Succeeded = 2,
               SucceededWithErrors = 3,
               Failed = 4,
               Aborted = 5
            }
"@
        }
    }#end Begin
}