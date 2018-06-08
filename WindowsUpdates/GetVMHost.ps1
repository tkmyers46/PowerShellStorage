function Get-VMHost {

if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest')
    {
    $vmparameters = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest'
        try
        {
            $vmhostname = $vmparameters.GetValue('PhysicalHostName')
        }
        catch
        {
            if ($vmhostname = $null)
            {
            $vmhostname = 'PhysicalHostName Parameter was null'
            }
            $vmhostname = 'This is not a VM'
        }
    $vmhostname
    }

}