# My PowerShell profile

This is my PowerShell profile. It's a work in progress. I will slowly add to as I find more useful functions and aliases.

## Installation

Your custom profile is stored in a file called `$PROFILE`. To find the file's location just run

```powershell
$PROFILE
```

Overwrite the contents of the file with some or all the contents of this repository.

## Functions

`hb [relative file path]` - Uploads the file to a hastebin server and returns the URL.

`ip` - Makes a curl request to https://api.ipify.org and returns your public IP address.

`weather` - Makes a curl request to wttr.in and returns the weather for your location.

`admin` or `sudo` - Opens a new PowerShell window as an administrator.

`Edit-Profile` - Opens the profile in Visual Studio Code.
