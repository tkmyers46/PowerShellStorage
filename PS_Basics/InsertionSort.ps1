param ( $theArray = @() )

$counter = 0

# $unsorted is the first index of the unsorted region
for ($unsorted = 1; $unsorted -lt $theArray.Count; $unsorted++)
{
	# Next item in the unsorted region
	$nextItem = $theArray[$unsorted]
	
	# Index of insertion in the sorted region
	$location = $unsorted
	
	while (($location -gt 0) -and `
		($theArray[$location - 1].CompareTo($nextItem) -gt 0))
	{
		$counter++
		# Shift to the right
		$theArray[$location] = $theArray[$location - 1]
		$location--
	}
	
	# Insert $nextItem into the sorted region
	$theArray[$location] = $nextItem
}

Write-Host "Array items: `t" $theArray.Count
Write-Host "Iterations: `t" $counter