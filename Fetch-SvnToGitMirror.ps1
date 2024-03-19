param (
    $Path
)

Set-Location $Path
git svn fetch
git push --mirror
