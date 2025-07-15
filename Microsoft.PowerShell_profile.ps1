function Update-Profile {
    Write-Host "Updating Owen3456's Profile" -ForegroundColor Cyan
    try {
        # Installs required programs
        winget install Microsoft.PowerShell JanDeDobbeleer.OhMyPosh ajeetdsouza.zoxide fzf Fastfetch-cli.Fastfetch gerardog.gsudo sharkdp.bat
    
        # Downloads profile and saves to file path
        $profile_Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $profile_Path = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        if (-not (Test-Path -Path $profile_Path)) {
            New-Item -ItemType File -Path $profile_Path -Force | Out-Null
        }
        Invoke-WebRequest -Uri $profile_Url -OutFile $profile_Path
    
        if (-not (Test-Path -Path "$Home\.config")) {
            New-Item -ItemType Directory -Path "$Home\.config" | Out-Null
        }
    
        # Download Oh My Posh config and saves to file path
        $ohMyPosh_Config_Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/nordcustom.omp.json"
        $ohMyPosh_Config_Path = "$HOME\.config\oh-my-posh\nordcustom.omp.json"
        if (-not (Test-Path -Path $ohMyPosh_Config_Path)) {
            $ohMyPosh_Config_Parent_Path = Split-Path -Path $ohMyPosh_Config_Path -Parent
            if (-not (Test-Path -Path $ohMyPosh_Config_Parent_Path)) {
                New-Item -ItemType Directory -Path $ohMyPosh_Config_Parent_Path | Out-Null
            }
            New-Item -ItemType File -Path $ohMyPosh_Config_Path -Force | Out-Null
        }
        Invoke-WebRequest -Uri $ohMyPosh_Config_Url -OutFile $ohMyPosh_Config_Path
        
        # Downloads fastfetch config and saves to file path
        $fastfetch_Config_Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"
        $fastfetch_Config_Path = "$HOME\.config\fastfetch\config.jsonc"
        if (-not (Test-Path -Path $fastfetch_Config_Path)) {
            $fastfetch_Directory_Path = Split-Path -Path $fastfetch_Config_Path -Parent
            if (-not (Test-Path -Path $fastfetch_Directory_Path)) {
                New-Item -ItemType Directory -Path $fastfetch_Directory_Path | Out-Null
            }
            New-Item -ItemType File -Path $fastfetch_Config_Path | Out-Null
        }
        Invoke-WebRequest -Uri $fastfetch_Config_Url -OutFile $fastfetch_Config_Path
    
        # Install Terminal-Icons
        Install-Module -Name Terminal-Icons -Repository PSGallery
    
        # Command to install a nerd font
        oh-my-posh font install
    
        # Output completion message
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
        Write-Host "  Updated Owen3456's Profile" -ForegroundColor Green
        Write-Host "  Ensure you are using a Nerd Font (https://www.nerdfonts.com/)" -ForegroundColor Yellow
        Write-Host "  Restart your terminal to apply changes" -ForegroundColor Yellow
        Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
        Write-Host ""
        Write-Host ""
        Write-Host ""
    
    }
    catch {
        # Output message with error if install fails
        Write-Error "Failed to update profile. Error: $_"
    }
}

# Uploads a file to a pastebin service and returns the URL
function hb {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$FilePath
    )

    if (-not (Test-Path $FilePath)) {
        Write-Error "File path does not exist: $FilePath"
        return
    }

    try {
        $Content = Get-Content $FilePath -Raw
    }
    catch {
        Write-Error "Failed to read file content. Error: $_"
        return
    }

    $uri = "https://bin.christitus.com/documents"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body ($Content | ConvertTo-Json) -ErrorAction Stop
        $hasteKey = $response.key
        $url = "https://bin.christitus.com/$hasteKey"
        Write-Output "Document uploaded successfully: $url"
    }
    catch {
        Write-Error "Failed to upload the document. Error: $_"
    }
}

function Get-IP {
    try {
        $privateIP = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -eq 'Manual' }).IPAddress
        Write-Output "Your private IP address is: $privateIP"

        $publicIP = Invoke-RestMethod -Uri 'https://ifconfig.me/ip' -TimeoutSec 5 -ErrorAction Stop
        Write-Output "Your public IP address is: $publicIP"
    }
    catch {
        Write-Error "Failed to retrieve IP address. Error: $_"
    }
}

Set-Alias ip Get-IP

# Opens a new PowerShell window as an administrator
function admin {
    if ($args.Count -gt 0) {
        $argList = "& '$args'"
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    }
    else {
        Start-Process wt -Verb runAs
    }
}

# Opens the PowerShell profile in VSCode
function Edit-Profile {
    code $PROFILE
    # Change code to your editor of choice (e.g. notepad $PROFILE) 
}

# Lists all files in the current directory (not subdirectories)
function ll { Get-ChildItem -Path $pwd -File }

# Finds file inside the current directory and subdirectories much faster than the built-in search in explorer.exe
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

# Set up aliases for find-file
Set-Alias ff find-file

# Unzips a file to the current directory
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# Kills any process containing the name given
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

# Outputs current system uptime
function uptime {
    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $uptimeFormatted = '{0} days, {1} hours, {2} minutes, {3} seconds' -f $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds
    Write-Output "System uptime: $uptimeFormatted"
}

# Runs Christitus' Windows Utility Script
function winutil {
    Invoke-RestMethod "https://christitus.com/win/" | Invoke-Expression
}

function winutilDev {
    Invoke-RestMethod "https://christitus.com/windev/" | Invoke-Expression
}

# Runs the Microsoft Activation Script for activating Windows and Office 365
function mas {
    Start-Process powershell.exe -verb runas -ArgumentList 'irm https://massgrave.dev/get | iex'
}

# Overwrite the default broken Clear-History function with one that works
function Clear-History {
    Remove-Item (Get-PSReadlineOption).HistorySavePath
}

function flushdns {
    try {
        Clear-DnsClientCache -ErrorAction Stop
        Write-Host "DNS cache has been successfully flushed." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to flush DNS cache. Error: $_"
    }
}

# Uses fzf to select a directory and change to it
function sd {
    try {
        # Get a list of directories
        $directories = Get-ChildItem -Directory -Recurse | Select-Object -ExpandProperty FullName

        # Use fzf to select a directory
        $selectedDirectory = $directories | fzf --height 100% --reverse --prompt "Select a directory: "

        if ($selectedDirectory) {
            Set-Location -Path $selectedDirectory
            Write-Host "Changed directory to $selectedDirectory" -ForegroundColor Green
        }
        else {
            Write-Host "No directory selected." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Error "Failed to select or change directory. Error: $_"
    }
}

# Makes a new directory and navigates to it
function mkcd {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$dirName
    )
    New-Item -ItemType Directory -Path $dirName | Out-Null
    Set-Location -Path $dirName
    Write-Host "Created and navigated to $dirName" -ForegroundColor Green
}

# Lists all installed winget packages
function Get-Packages {
    winget list | Format-Table -AutoSize
}

function Invoke-FuzzyDelete {
    <#
    .SYNOPSIS
        Uses fzf to search for files and directories, deletes the selected item after confirmation, and keeps the fzf window open for multiple selections.
    .DESCRIPTION
        This function leverages PowerShell's Get-ChildItem to list files and directories, fzf for fuzzy searching. It prompts for confirmation showing the full path before deleting an item and allows continuous selection until the user exits fzf.
    .EXAMPLE
        Invoke-FuzzyDelete
        # Opens fzf to search for files and directories, prompts for deletion confirmation, and keeps the fzf window open for further selections.
    .NOTES
        Requires only fzf installed (e.g., via winget or Chocolatey).
        Ensure fzf is in your PATH.
    #>
    [CmdletBinding()]
    param (
        [string]$SearchPath = ".",  # Default to current directory
        [string]$FzfPrompt = "Select item to delete> "
    )

    # Ensure fzf is installed
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Error "fzf is not installed. Please install it using 'winget install junegunn.fzf' or similar."
        return
    }

    # Configure fzf options for multi-selection and preview
    $fzfOptions = @(
        '--multi'
        "--prompt=$FzfPrompt"
        '--preview=if (Test-Path {} -PathType Leaf) { Get-Content {} | Select-Object -First 30 } else { Get-ChildItem {} | Format-Table -AutoSize }'
        '--preview-window=right,60%,border-left'
        '--bind=ctrl-r:reload(Get-ChildItem -Path . -Recurse -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)'
        '--header-first'
        '--header=CTRL-R: Refresh | ENTER: Select | ESC: Exit'
    )

    while ($true) {
        # Get all files and directories using PowerShell, pipe to fzf for selection
        $selectedItems = Get-ChildItem -Path $SearchPath -Recurse -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName | & fzf @fzfOptions

        # Exit if no selection (e.g., user presses ESC)
        if (-not $selectedItems) {
            Write-Host "No item selected. Exiting."
            break
        }

        # Process each selected item (supports multi-selection)
        foreach ($item in $selectedItems) {
            # Get the full path of the selected item
            $fullPath = Resolve-Path $item -ErrorAction SilentlyContinue
            if (-not $fullPath) {
                Write-Warning "Could not resolve path for: $item"
                continue
            }

            # Prompt for confirmation with full path
            Write-Host "Selected item: $fullPath"
            $confirm = Read-Host "Are you sure you want to delete '$fullPath'? (y/n)"
            if ($confirm -eq 'y' -or $confirm -eq 'Y') {
                try {
                    Remove-Item -Path $fullPath -Recurse -Force -ErrorAction Stop
                    Write-Host "Deleted: $fullPath"
                }
                catch {
                    Write-Error "Failed to delete '$fullPath': $_"
                }
            }
            else {
                Write-Host "Deletion canceled for: $fullPath"
            }
        }
    }
}

Set-Alias fzd Invoke-FuzzyDelete


# MARK: Location Shortcuts

# Shortcut to Documents folder
function doc { Set-Location -Path $HOME\Documents }

# Shortcut to Downloads folder
function dl { Set-Location -Path $HOME\Downloads }

# Shortcut to GitHub folder
function gh { Set-Location -Path $HOME\Documents\GitHub }

# Shortcut to C: drive
function c { Set-Location -Path C:\ }

# MARK: Other

# Set the prompt to use oh-my-posh
oh-my-posh init pwsh --config "$HOME/.config/oh-my-posh/nordcustom.omp.json" | Invoke-Expression

# Set up zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
if (Get-Alias cd -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cd
}
Set-Alias cd z

# bat alias
Set-Alias cat bat

# Import Terminal-Icons module
Import-Module -Name Terminal-Icons
