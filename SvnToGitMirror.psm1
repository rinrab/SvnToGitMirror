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
        $commandArgs = "-Command . '$fetchCommand' -Path '$mirrorWorkingDirectory'"

        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $commandArgs
        $trigger = New-ScheduledTaskTrigger -AtLogon
        $settings = New-ScheduledTaskSettingsSet

        $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
        $task | Register-ScheduledTask -TaskName $Name -TaskPath "SvnToGitMirror" -Force
    }

    end {
        Set-Location $path
    }
}
