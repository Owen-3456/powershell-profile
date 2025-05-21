# My PowerShell profile

<div align="right">
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/t/Owen-3456/powershell-profile">
<img src="https://img.shields.io/github/last-commit/Owen-3456/powershell-profile">
<img src="https://wakatime.com/badge/github/Owen-3456/powershell-profile.svg">
</div>

This is my PowerShell profile. It's a work in progress. I will slowly add to as I find more useful functions and aliases.

Designed with a Nord theme to match my [Windows Terminal Nord Colour Scheme](https://github.com/Owen-3456/wt-nord)

## Installation

To install the profile, run the following command in PowerShell:

```ps1
irm "owen3456.xyz/pwsh" | iex
```

or

```ps1
irm "https://raw.githubusercontent.com/Owen-3456/powershell-profile/refs/heads/main/Microsoft.PowerShell_profile.ps1" | iex
```

This will install:
- [PowerShell 7](https://github.com/PowerShell/PowerShell)
- [Oh My Posh](https://ohmyposh.dev/)
- [Zioxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [Gsudo](https://github.com/gerardog/gsudo)
- [bat](https://github.com/sharkdp/bat)

You need to install a [Nerd font](https://www.nerdfonts.com/) to use the profile. Set the font in your terminal.

## Zoxide

`cd` function now uses [Zioxide](https://github.com/ajeetdsouza/zoxide). It's a smarter `cd` command that tracks your most used directories

## Gsudo

[Gsudo](https://github.com/gerardog/gsudo) is a sudo alternative for Windows. It allows you to run commands as an administrator with `gsduo` or `sudo`

## Modules

- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)

## New Functions

Note: Some functions missing from the list

`Update-PowerShell` - Updates PowerShell to the latest version. Is ran on startup.

`Update-Profile` - Updates profile from GitHub and all dependencies.

`Reload-Profile` - Reloads the profile.

`hb [relative file path]` - Uploads the file to a hastebin server and returns the URL.

`ip` - Makes a curl request to https://api.ipify.org and returns your public IP address.

`admin` - Opens a new PowerShell window as an administrator.

`Edit-Profile` - Opens the profile in Visual Studio Code.

`ll` - Lists contents of directory excluding other directories.

`find-file [file name]` or `ff [file name]` - Searches for a file in the current directory and all subdirectories.

`unzip` - Unzips a file into the current directory.

`pkill [process]` - Kills any process with the name.

`uptime` - Returns the uptime of the computer.

`reload` - Reloads the profile.

`winutil` - Opens [Windows Utility](https://github.com/ChrisTitusTech/winutil).

`mas` - Runs [Microsoft Activation Script](https://github.com/massgravel/Microsoft-Activation-Scripts).

`flushdns` - Flushes the DNS cache.

`sd` - Runs a fuzzy find and changes to the selected directory.

## Tweaked Functions

`Clear-History` - The default `Clear-History` command doesn't work. It get overwritten with a command that does work.

## Location Shortcuts

`doc` - Opens the Documents folder.

`dl` - Opens the Downloads folder.

`gh` - Opens the GitHub folder (...\Documents\GitHub).

`c` - Opens the C: drive.
