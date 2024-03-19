param (
    $Path
)

while (1) {
    Set-Location $Path
    git svn fetch
    git push --mirror
    Start-Sleep -Seconds (60 * 2) # Every two minutes
}
