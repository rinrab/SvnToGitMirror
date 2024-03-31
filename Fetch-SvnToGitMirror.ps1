param (
    $Path,
    $GitRepositoryUrl
)

Start-Transcript -path "C:\Users\Administrator\Documents\log.txt" -append

Set-Location $Path

"" | & git svn fetch
"" | & git svn rebase

git branch -f trunk origin/trunk
git push --tags $GitRepositoryUrl trunk --force

$branches = $(git branch -r --list 'origin/*').Trim()

foreach ($svnBranch in $branches) {
    $gitBranch = $svnBranch.TrimStart("origin/")

    if ($gitBranch -ne "master" -and $gitBranch -ne "trunk") {
        if ($gitBranch -notmatch "^tags/.*") {
            git branch -f $gitBranch $svnBranch
            git push --tags $GitRepositoryUrl $gitBranch --force
        }
        else {
            git tag --force $gitBranch.TrimStart("tags/") $svnBranch
        }
    }
}

git push --tags $GitRepositoryUrl

Stop-Transcript
