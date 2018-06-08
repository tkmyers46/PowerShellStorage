$MFA_MASTER = "CO1-PFA-001"

$mfaAmericas = 
    "CO1-PFA-001",
    "CO1-PFA-002",
    "CO1-PFA-003",
    "CO1-PFA-004",
    "CO1-PFA-005"
    
$mfaROW = 
    "DB3-PFA-001",
    "DB3-PFA-002",
    "SIN-PFA-001",
    "SIN-PFA-002",
    "BAY-PFA-001",
    "BAY-PFA-002"
    
    
    
 <#
 Parameter setup for MFA scripts:
 ================================
 
 param (
    [ValidateSet("Americas", "ROW", "All"]
    $MfaServerGroup,
    
    [Parameter(mandatory=$true)]
    $SearchQuery,
    
    $Server="$env:COMPUTERNAME",
    
    [datetime]$TimeStamp
)

$path = Split-Path -parent $MyInvocation.MyCommand.Definition
. $path\MFA-common.ps1

$mfaAll = $null
if ($MfaServerGroup) {
    switch ($MfaServerGroup) {
        "Americas" {$mfaAll = $mfaAmericas; break}
        "ROW"      {$mfaAll = $mfaROW; break}
        "All"      {$mfaAll = $mfaAmericas + $mfaROW; break}
    }
} else {
    $mfaAll = $Server
}

foreach ($mfaServer in $mfaAll) {

}

#>



