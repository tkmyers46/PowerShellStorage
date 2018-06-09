# Loops
# Reserved words do, for, foreach, while

<#
for (Set the loop counter; evaluate the loop counter; update the counter) {
    Do something
}
#>

for ($count =1; $count -lt 5; $count++){
    Write-Host $count
}

# do something at least once, and then stop when the condition is met
$count = 5
do {
    Write-Host 'Hello'
    $count--
} while ($count -gt 0)

# while some condition is true, keep doing something
$count = 5
while ($count -gt 0){
    Write-Host $count " is greater than zero"
    $count--
}

<#
foreach(member in collection){
    Do something that with the object
}
#>

# foreach student in the array of [string]$students, write their name and the number of letters
$students = @('Bob', 'Amy', 'John', 'Sue')
foreach($student in $students){
    Write-Host $student, $student.Length
}
