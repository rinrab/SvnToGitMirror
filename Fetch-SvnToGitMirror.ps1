param (
    $Path,
    $GitRepositoryUrl
)

Set-Location $Path

git svn fetch
git svn rebase
git fetch --tags $GitRepositoryUrl

git branch -f origin/trunk trunk
git push --tags $GitRepositoryUrl trunk

$branches = $(git branch -r --list 'origin/*').Trim()

foreach ($svnBranch in $branches) {
    $gitBranch = $svnBranch.TrimStart("origin/")

    if ($gitBranch -ne "master" -and $gitBranch -notmatch "^tags/.*" -and $gitBranch -ne "trunk") {
        git branch -f $gitBranch $svnBranch
        git push --tags $GitRepositoryUrl $gitBranch
    }
}
