Param (
    [string] $message = "update: some new changes",
    [switch] $set_minor = $false,
    [switch] $set_major = $false
)

if ($set_major.IsPresent -And $set_minor.IsPresent)
{
    Write-Host "Error: parameters set_major and set_minor are mutually exclusive"
    Exit(0)
}

$branch = $(git branch --show-current)

git fetch --all --tags

git pull origin $branch

git add .

git commit -m $message

if ($branch.Equals("master"))
{
    if ($set_major.IsPresent)
    {
        $(git describe --tags $(git rev-list --tags --max-count=1)) -match "([0-9]+)\.([0-9]+)\.([0-9]+)"
        $major = [int]$Matches[1] + 1
        $minor = [int]$Matches[2]
        $patch = [int]$Matches[3]
        $version = "$($major).0.0"
        $version
        git tag -a $version -m $version
    }

    elseif ($set_minor.IsPresent)
    {
        $(git describe --tags $(git rev-list --tags --max-count=1)) -match "([0-9]+)\.([0-9]+)\.([0-9]+)"
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2] + 1
        $patch = [int]$Matches[3]
        $version = "$($major).$($minor).0"
        $version
        git tag -a $version -m $version
    }

    else 
    {
        $(git describe --tags $(git rev-list --tags --max-count=1)) -match "([0-9]+)\.([0-9]+)\.([0-9]+)"
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2]
        $patch = [int]$Matches[3] + 1
        $version = "$($major).$($minor).$($patch)"
        $version
        git tag -a $version -m $version
    }
}

git push -u origin $branch --follow-tags
