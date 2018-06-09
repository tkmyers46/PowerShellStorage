# Functions are the basis for Commandlets
# Commandlets are functions that are installed/imported with a module

# Functions may be defined anytime throughout a session
function DontGet-Item (){
    Write-Host "Nothing changed"
    Write-Host "I'm not returning an item"
}

function DontGet-TravisItem (){
    Param(
        [string]$Name
    )
    Write-Host ("I'm not returning $Name anything!!!") -ForegroundColor Green
}
