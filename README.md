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

2. Set your terminal font to JetBrainsMono Nerd Font.

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

### Custom Functions

The profile also adds many new commands, which are listed below:

`Update-Profile` - Updates profile from GitHub and all dependencies.

`hb [path]` - Uploads the file to a hastebin server and returns the URL.

`ip` - Retrieves and displays both your private and public IP addresses.

`ll` - Lists contents of directory excluding other directories.

`ff [name]` - Searches for a file in the current directory and all subdirectories.

`pkill [process]` - Kills any process with the specified name.

`uptime` - Returns the uptime of the computer.

`winutil` - Opens [Windows Utility](https://github.com/ChrisTitusTech/winutil).

`winutilDev` - Opens the development version of Windows Utility.

`mas` - Runs [Microsoft Activation Script](https://github.com/massgravel/Microsoft-Activation-Scripts).

`Clear-History` - Properly clears PowerShell command history (fixes the broken default implementation).

`flushdns` - Flushes the DNS cache.

`mkcd [path]` - Creates a directory and changes to it.

`Get-Packages` - Lists all installed packages from winget.

`fzd` - Uses fzf to search for files and directories with multi-selection support, then deletes selected items after confirmation.

`wup` - Shows available winget updates and allows selective updating of packages using fzf.

### Custom Aliases

`cd` - Alias for `z` (zoxide smart directory navigation).

`cat` - Alias for `bat` (enhanced cat with syntax highlighting).
