# PowerShell variables
# Environnment, Session, Automatic
$env:COMPUTERNAME # Environment

function Get-ComputerName (){
    return $env:COMPUTERNAME
}


$false, $true # Automatic
$Error
$Error.Clear()
$true.fix()

# Data Types
$isRetired = $true
$isRetired.GetType()

$implicitString = 'Travis' # Casts new variable as String object NOT LITERAL
$implicitString.GetType()

$intNumber = 4 # Casts new variable as Int32
$intNumber.GetType()

$arrayList = @('Travis', 'Kim', 'Christian') # Casts new variable as an Array of String Objects
$arrayList.GetType()
$arrayList[0]
$arrayList[0].GetType()
$arrayList.GetValue(1)
$arrayList.Count
$arrayList.GetValue()

$arrayList = @(2, 6, 12, 'travis') # Casts new variable as an Array of Int32 Objects
$arrayList.GetType()
$arrayList[0]
$arrayList[3].GetType()
