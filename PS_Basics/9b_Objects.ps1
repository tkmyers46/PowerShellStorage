# Objects
# Properties and Methods

# String object 'Array of char'
$mystring = 'Travis'
$mystring.Contains('r') # Method that checks if the string array contains the character 'r'
$mystring.ToUpper()     # Method that returns the string in upper case
$mystring.IndexOf('v')  # Method that returns the int location of the character in the array
$mystring.Length        # Attribute, gets the number of characters in the array or the 'Length' of the array

$mystring | select Length

# Array of String objects
$stringArray = @('Bob', 'Amy', 'John', 'Sue')
$stringArray.Count      # Attribute, gets the number of objects 'String objects' in the array
$stringArray.Length     # Attribute, gets the length of the array
$stringArray.GetValue(2)# Go to Index 2 in the array and return the value
$stringArray[0]         # Access array element 0

# Hash table (two dimensional arrays)
# Columns 0    1    2
# Row 0   1    2    3
# Row 1   Amy  Bob  Jill
# $twoDimensionalArray[Row][Column]
$twoDimensionalArray = @(1, 2, 3),@('Amy', 'Bob', 'Jill')
$twoDimensionalArray[0][2]
$twoDimensionalArray[1][1]

$twoDimensionalArray | select Count, Rank, IsReadOnly

$bicycle = [PSCustomObject]@{
    Wheels = 2
    Brand = 'Schwinn'
}

Add-Member -MemberType ScriptMethod -InputObject $bicycle -Name "Model" -Value {return "SuperFly2000"}

$bicycle.Model()
$bicycle | Format-Table Wheels, Brand

Get-Member -InputObject $bicycle -Name Model
