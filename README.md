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

## Example 1

```powershell
New-SvnToGitMirror -Name "my_mirror" -SvnRepositoryUrl "https://svn.example.com/svn/myrepo" -GitRepositoryUrl "https://www.github.com/octocat/myrepo-mirror"
```

> [!NOTE]
> Don't forget to create repository.
