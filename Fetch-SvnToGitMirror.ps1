param (
    $Path,
    $GitRepositoryUrl
)

Set-Location $Path

git svn fetch
git svn rebase
git fetch --tags $GitRepositoryUrl

$branches = $(git branch -r --list 'origin/*').Trim()

foreach ($svnBranch in $branches) {
    $gitBranch = $svnBranch.TrimStart("origin/")
    git branch -f $gitBranch $svnBranch
    git push --tags $GitRepositoryUrl $gitBranch
}
