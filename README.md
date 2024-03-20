# SvnToGitMirror

A simple PowerShell module for creating mirror from subversion to git.

## Installation

1. Install git
2. Install module using the following command:
```powershell
Install-Module -Name SvnToGitMirror
```

## Syntax

```powershell
New-SvnToGitMirror [-Name] <string> [-SvnRepositoryUrl] <uri> [-GitRepositoryUrl] <uri> [<CommonParameters>]
```

## Example

> [!IMPORTANT]
> Run the command as administrator.

### Initializing repository

```powershell
$svnUrl = "https://svn.example.com/svn/myrepo"
$gitUrl = "https://www.github.com/octocat/myrepo-mirror"
New-SvnToGitMirror -Name "my_mirror" -SvnRepositoryUrl $svnUrl -GitRepositoryUrl $gitUrl

Initialized empty Git repository in...
...
Everything up-to-date
SUCCESS: The scheduled task "SvnToGitMirror\my_mirror" has successfully been created.
Please insert the following line to your post commit hook:
schtasks.exe /RUN /TN SvnToGitMirror\my_mirror
```

> [!NOTE]
> Don't forget to create a git repository.

### Syncronization via post commit hook

After initializing the mirror, create a [post-commit hook](https://svnbook.red-bean.com/en/1.7/svn.ref.reposhooks.post-commit.html) in your repository and insert there the following line:

```powershell
schtasks.exe /RUN /TN SvnToGitMirror\my_mirror
```

It's required to sync new subversion revisions into git.
