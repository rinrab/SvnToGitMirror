param (
    $Path
)

Set-Location $Path
git svn fetch
git push origin --mirror
