function New-SvnToGitMirror {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [Uri]
        $SvnRepositoryUrl,

        [Parameter(Mandatory)]
        [Uri]
        $GitRepositoryUrl
    )

    begin {
        $path = Get-Location
    }

    process {
        $documentsPath = [Environment]::GetFolderPath("MyDocuments")
        $workingDirectoryBase = "$documentsPath\mirrors"
        $mirrorWorkingDirectory = "$workingDirectoryBase\$Name"

        if (Test-Path $mirrorWorkingDirectory) {
            Set-Location $mirrorWorkingDirectory

            git svn fetch
        }
        else {
            mkdir $mirrorWorkingDirectory
            git svn clone -s $SvnRepositoryUrl $mirrorWorkingDirectory
        }

        git remote remove origin
        git remote add origin $GitRepositoryUrl

        git push --mirror

        $fetchCommand = (Get-Command $PSScriptRoot\Fetch-SvnToGitMirror.ps1).Source
        $sid = (get-localuser -Name $env:USERNAME).SID.Value
        $config = Get-Content "$PSScriptRoot\TaskConfig.xml"
        $config = $config -replace "{{sid}}", $sid
        $config = $config -replace "{{scriptpath}}", $fetchCommand
        $config = $config -replace "{{mirrorpath}}", $mirrorWorkingDirectory
        $configPath = "$env:TEMP\SvnToGitMirror-TaskConfig.xml"
        $config | Set-Content -Path $configPath

        schtasks.exe /Create /TN "SvnToGitMirror\$Name" /XML $configPath /F
    }

    end {
        Set-Location $path
    }
}
