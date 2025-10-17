# My PowerShell profile

<div align="right">
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/t/Owen-3456/powershell-profile">
<img src="https://img.shields.io/github/last-commit/Owen-3456/powershell-profile">
<img src="https://wakatime.com/badge/github/Owen-3456/powershell-profile.svg">
</div>

A custom PowerShell 7 profile that adds many new features and tweaks existing ones.

## Installation

1. To install the profile, run the following command in PowerShell:

```ps1
irm "owen3456.xyz/pwsh" | iex
```

2. Download and install a Nerd Font from [Nerd Fonts](https://www.nerdfonts.com/) or run the following command after installing the profile, personally I use JetBrains Mono Nerd Font.:

```ps1
oh-my-posh font install
```

3. Set your terminal font to the Nerd Font you installed.


## Features

### Packages and Tools

This profile is designed to be used with [PowerShell 7](https://github.com/PowerShell/PowerShell). It will automatically install PowerShell 7 alongside:

- [Starsihip](https://starship.rs/) - A cross-shell prompt.
- [Zioxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command that tracks your most used directories.
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder.
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch) - A fast and highly customizable system information tool.
- [Gsudo](https://github.com/gerardog/gsudo) - A sudo alternative for Windows.
- [bat](https://github.com/sharkdp/bat) - A cat clone with syntax highlighting and Git integration.
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) - Adds icons to your terminal.

A custom Nord style Oh My Posh theme is also included.

The profile fixes the Clear-History command, which is broken by default.

### Custom Functions and Aliases

The profile also adds many new commands, which are listed below:

`Update-Profile` - Updates profile from GitHub and all dependencies.

`hb [relative file path]` - Uploads the file to a hastebin server and returns the URL.

`ip` or `Get-IP` - Makes a curl request to https://api.ipify.org and returns your public IP address.

`ll` - Lists contents of directory excluding other directories.

`ff [file name]` or `find-file [filename]` - Searches for a file in the current directory and all subdirectories.

`pkill [process]` - Kills any process with the name.

`uptime` - Returns the uptime of the computer.

`winutil` - Opens [Windows Utility](https://github.com/ChrisTitusTech/winutil). `wintuilDev` opens the developer branch.

`mas` - Runs [Microsoft Activation Script](https://github.com/massgravel/Microsoft-Activation-Scripts).

`flushdns` - Flushes the DNS cache.

`mkcd [directory name]` - Creates a directory and changes to it.

`Get-Packages` - Lists all installed packages from winget.

`fzd` or `Invoke-FuzzyDelete` - Runs a fuzzy find and deletes the selected file or directory.

`wup` or `Update-SelectedPackages` - Runs winget upgrade and allows you to select which packages to upgrade.

### Location Shortcuts

`doc` - Opens the Documents folder.

`dl` - Opens the Downloads folder.

`gh` - Opens the GitHub folder (...\Documents\GitHub).

`c` - Opens the C: drive.
