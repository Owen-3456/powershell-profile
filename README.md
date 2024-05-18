# My PowerShell profile

This is my PowerShell profile. It's a work in progress. I will slowly add to as I find more useful functions and aliases.

## Installation

To install the profile, run the following command in PowerShell:

```
irm https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/install.ps1 | iex
```

This will install the PowerShell 7, [Oh My Posh](https://ohmyposh.dev/) and [Zioxide](https://github.com/ajeetdsouza/zoxide) as well.

You need to install a [Nerd font](https://www.nerdfonts.com/) to use the theme. Set the font in Windows Terminal.

## Functions

`Update-PowerShell` - Updates PowerShell to the latest version. Is ran on startup.

`Update-Profile` - Updates the profile to the latest version.

`Reload-Profile` - Reloads the profile.

`hb [relative file path]` - Uploads the file to a hastebin server and returns the URL.

`ip` - Makes a curl request to https://api.ipify.org and returns your public IP address.

`admin` or `sudo` - Opens a new PowerShell window as an administrator.

`Edit-Profile` - Opens the profile in Visual Studio Code.

`ll` - Lists contents of directory excluding other directories.

`find-file [file name]` or `ff [file name]` - Searches for a file in the current directory and all subdirectories.

`unzip` - Unzips a file into the current directory.

`pkill [process]` - Kills any process with the name.

`uptime` - Returns the uptime of the computer.

`reload` - Reloads the profile.

`winutil` - Opens [Windows Utility](https://github.com/ChrisTitusTech/winutil).

`mas` - Runs [Microsoft Activation Script](https://github.com/massgravel/Microsoft-Activation-Scripts).

`Clear-History` - The default `Clear-History` command doesn't work. It get overwritten with a command that does work.

## Location Shortcuts

`doc` - Opens the Documents folder.

`dl` - Opens the Downloads folder.

`gh` - Opens the GitHub folder.

`c` - Opens the C: drive.
