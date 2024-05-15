# My PowerShell profile

This is my PowerShell profile. It's a work in progress. I will slowly add to as I find more useful functions and aliases.

## Installation

Your custom profile is stored in a file called `$PROFILE`. To find the file's location just run

```powershell
$PROFILE
```

Overwrite the contents of the file with some or all the contents of this repository.

## Functions

`Update-PowerShell` - Updates PowerShell to the latest version. Is ran on startup.

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

## Location Shortcuts

`doc` - Opens the Documents folder.

`dl` - Opens the Downloads folder.

`gh` - Opens the GitHub folder.

`c` - Opens the C: drive.
