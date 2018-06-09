# Operators
# MATH
$total = 8
$total = 6 + 9
$total = 6 * 9
$total = (6 + 9) * 8/2

# Modulo
$total % 8 # 60 divided by 8 = 60/(8 * 7) 'Returns the remainder 4'

# Compound MATH
$total += $total # Equivalent to $total = $total + $total
$total -= 5 # Equivalent to $total = $total - 5

# Increment/Decrement before and after returning the value
Write-Host (++$total) # Increment or increase $total by 1, then return the value
Write-Host ($total++) # Return the value $total then increment or increase by 1

# Modulo example 'Is the number even ?'
42 % 2 # Even numbers divided by 2 always return 0
9 % 2  # Odd numbers divided by 2 always have a remainder

# Values are/not equal
$sixteen = 16
$eighteen = 18
$sixteen -eq $eighteen
$sixteen -lt $eighteen
16 -gt 18
16 -ge 16
16 -gt 16
16 -le 18
