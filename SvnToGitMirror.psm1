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
            Set-Location $mirrorWorkingDirectory
            git svn clone -s $SvnRepositoryUrl $mirrorWorkingDirectory --revision 385
        }

        & $PSScriptRoot\Fetch-SvnToGitMirror -Path $mirrorWorkingDirectory -GitRepositoryUrl $GitRepositoryUrl

        $fetchCommand = (Get-Command $PSScriptRoot\Fetch-SvnToGitMirror.ps1).Source
        $sid = (get-localuser -Name $env:USERNAME).SID.Value
        $config = Get-Content "$PSScriptRoot\TaskConfig.xml"
        $config = $config -replace "{{sid}}", $sid
        $config = $config -replace "{{scriptpath}}", $fetchCommand
        $config = $config -replace "{{mirrorpath}}", $mirrorWorkingDirectory
        $config = $config -replace "{{mirrorurl}}", $GitRepositoryUrl
        $configPath = "$env:TEMP\SvnToGitMirror-TaskConfig.xml"
        $config | Set-Content -Path $configPath

        schtasks.exe /Create /TN "SvnToGitMirror\$Name" /XML $configPath /F

        $scheduler = New-Object -ComObject "Schedule.Service"
        $scheduler.Connect()
        $folder = $scheduler.GetFolder("\").GetFolder("SvnToGitMirror")
        $TaskX = $folder.GetTask($Name)
        $acl = $TaskX.GetSecurityDescriptor(0xF)

        # Everyone
        $acl = $acl + '(A;;GRGX;;;AU)'
        $TaskX.SetSecurityDescriptor($acl, 0)

        Write-Host "Please insert the following line to your post commit hook:"
        Write-Host "schtasks.exe /RUN /TN SvnToGitMirror\$Name"
    }

    end {
        Set-Location $path
    }
}
