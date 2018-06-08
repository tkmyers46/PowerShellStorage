param
(
    # Project file name without extension.
    [Parameter(Mandatory=$true,
               Position=0)]
    [String]
    $Name,

    # Target NuGet repository, which can be local, but defaults to the offical one.  Use $null to skip pushing the package.
    [Parameter(Position=1)]
    [String]
    $TargetRepo = 'http://iambuild01'
)

$scriptPath = \Split-Path -Parent $MyInvocation.MyCommand.Definition

$project = Get-ChildItem -Path $scriptPath -Include "$($Name).csproj" -Exclude *.Test.* -Recurse
if (!$project)
{
    $project = Get-ChildItem -Path $scriptPath -Include "$($Name).nuspec" -Exclude *.Test.* -Recurse
    if (!$project)
    {
        Write-Warning "Project $Name not found."
        return
    }
}

$nuspec = Join-Path $project.Directory "$($Name).nuspec"
if(!$(Test-Path($nuspec)))
{
    Write-Warning "Nuspec not found for $Name.  Please see http://vstfwsspga/sites/Consol_06_TPC3/IAM-Common/Project%20Wiki/Adding%20a%20New%20Library.aspx."
    return
}

$projectPath = """$($project.FullName)"""
$outputPath = """$($project.Directory)"""
.\.nuget\nuget pack $projectPath -Build -Prop Configuration=Release -IncludeReferencedProjects -OutputDirectory $outputPath -Verbosity detailed | Tee-Object -Variable results

if ($TargetRepo -ne $null)
{
    for ($i = 0; $i -lt $results.Length; $i++)
    {
        if ($results[$i].StartsWith("Id: "))
        {
            $id = $results[$i].Substring(4)
        }
        if ($results[$i].StartsWith("Version: "))
        {
            $version = $results[$i].Substring(9)
        }
        if ($results[$i].StartsWith("Successfully created package"))
        {
            $outFile = [Regex]::Match($results[$i], "^.*'(.*)'.*$").Groups.Item(1)
        }
    }

    $isLocalRepo = Test-Path($TargetRepo)
    if ($isLocalRepo -eq $false)
    {
        $packageList = .\.nuget\nuget list $id -Source "$TargetRepo/nuget"
        if ($packageList -isnot [system.array])
        {
            $packageList  = @($packageList)
        }

        for ($i = 0; $i -lt $packageList.Length; $i++)
        {
            if ($packageList[$i] -eq "$id $version")
            {
                Write-Warning "Version $version of $id is already published.  Please increment the version number or add a prerelease string like '-alpha1' to your version in AssemblyInfo."
                return
            }
        }
    }

    .\.nuget\nuget push $outFile -Source $TargetRepo -Verbosity detailed
}
