Param (
    [string] $message = "update: some new changes"
)

$branch = $(git branch --show-current)

git fetch --all --tags

git pull origin $branch

git add .

git commit -m $message

git push -u origin $branch
