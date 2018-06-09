# Conditionals
# Reserved words else, elseif, if

if($true){
    Write-Host "You know it's true"
}
$sixteen = 16; $eighteen = 18; $six = 6; $eight = 8

# if 6 < 8 return the boolean true, if not, return false
if($six -lt $eight){

    return $true

} else {

    return $false
}

$travis = 'travis'
# elseif (Some other condition)
if($six -gt $eight){

    return $true

} elseif($travis.Contains('r')) {

    return $true

} else {

    return 'Neither'
}
