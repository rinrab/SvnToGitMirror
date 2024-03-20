param (
    $Path,
    $GitRepositoryUrl
)

Set-Location $Path

git svn fetch

git checkout origin/trunk
git push $GitRepositoryUrl origin/trunk --force
