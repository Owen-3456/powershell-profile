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
        Uses fzf to search for files and directories, deletes the selected items after confirmation.
    .DESCRIPTION
        This function leverages PowerShell's Get-ChildItem to list files and directories, fzf for fuzzy searching with multi-selection support. It prompts for confirmation showing all selected items before deleting them.
    .EXAMPLE
        Invoke-FuzzyDelete
        # Opens fzf to search for files and directories with multi-selection, prompts for deletion confirmation.
    .NOTES
        Requires only fzf installed (e.g., via winget or Chocolatey).
        Ensure fzf is in your PATH.
        Use TAB to select multiple items, ENTER to confirm selection.
    #>
    [CmdletBinding()]
    param (
        [string]$SearchPath = ".",  # Default to current directory
        [string]$FzfPrompt = "Select items to delete (TAB for multi-select)> ",
        [switch]$ConfirmEach  # If specified, confirm each item individually instead of all at once
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
        '--header=TAB: Select/Deselect | CTRL-R: Refresh | ENTER: Confirm | ESC: Exit'
    )

    # Get all files and directories using PowerShell, pipe to fzf for selection
    $selectedItems = Get-ChildItem -Path $SearchPath -Recurse -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName | & fzf @fzfOptions

    # Exit if no selection (e.g., user presses ESC)
    if (-not $selectedItems) {
        Write-Host "No items selected. Exiting." -ForegroundColor Yellow
        return
    }

    # Ensure $selectedItems is an array
    if ($selectedItems -is [string]) {
        $selectedItems = @($selectedItems)
    }

    Write-Host "`nSelected $($selectedItems.Count) item(s) for deletion:" -ForegroundColor Cyan
    foreach ($item in $selectedItems) {
        $fullPath = Resolve-Path $item -ErrorAction SilentlyContinue
        if ($fullPath) {
            Write-Host "  - $fullPath" -ForegroundColor White
        } else {
            Write-Host "  - $item (could not resolve path)" -ForegroundColor Red
        }
    }

    if ($ConfirmEach) {
        # Confirm each item individually
        foreach ($item in $selectedItems) {
            $fullPath = Resolve-Path $item -ErrorAction SilentlyContinue
            if (-not $fullPath) {
                Write-Warning "Could not resolve path for: $item"
                continue
            }

            Write-Host "`nSelected item: $fullPath"
            $confirm = Read-Host "Are you sure you want to delete '$fullPath'? (y/n)"
            if ($confirm -eq 'y' -or $confirm -eq 'Y') {
                try {
                    Remove-Item -Path $fullPath -Recurse -Force -ErrorAction Stop
                    Write-Host "Deleted: $fullPath" -ForegroundColor Green
                }
                catch {
                    Write-Error "Failed to delete '$fullPath': $_"
                }
            }
            else {
                Write-Host "Deletion canceled for: $fullPath" -ForegroundColor Yellow
            }
        }
    } else {
        # Confirm all items at once
        Write-Host "`nAre you sure you want to delete ALL $($selectedItems.Count) selected item(s)?" -ForegroundColor Red
        $confirm = Read-Host "(y/n)"
        
        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            $successCount = 0
            $failCount = 0
            
            foreach ($item in $selectedItems) {
                $fullPath = Resolve-Path $item -ErrorAction SilentlyContinue
                if (-not $fullPath) {
                    Write-Warning "Could not resolve path for: $item"
                    $failCount++
                    continue
                }

                try {
                    Remove-Item -Path $fullPath -Recurse -Force -ErrorAction Stop
                    Write-Host "Deleted: $fullPath" -ForegroundColor Green
                    $successCount++
                }
                catch {
                    Write-Error "Failed to delete '$fullPath': $_"
                    $failCount++
                }
            }
            
            Write-Host "`nDeletion Summary:" -ForegroundColor Cyan
            Write-Host "  Successfully deleted: $successCount items" -ForegroundColor Green
            if ($failCount -gt 0) {
                Write-Host "  Failed to delete: $failCount items" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Deletion canceled for all selected items." -ForegroundColor Yellow
        }
    }
}

Set-Alias fzd Invoke-FuzzyDelete

function Update-SelectedPackages {
    <#
    .SYNOPSIS
        Shows available winget updates and allows selective updating of packages.
    .DESCRIPTION
        This function lists all available winget updates and uses fzf for multi-selection,
        then updates only the selected packages.
    .EXAMPLE
        Update-SelectedPackages
    .NOTES
        Requires winget and fzf to be installed.
    #>
    [CmdletBinding()]
    param()

    # Check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Error "winget is not installed. Please install it from the Microsoft Store or App Installer."
        return
    }

    # Check if fzf is installed
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Error "fzf is not installed. Please install it using 'winget install fzf'."
        return
    }

    try {
        Write-Host "Checking for updates..." -ForegroundColor Cyan
        
        # Get list of available updates
        $updates = winget upgrade | Out-String -Stream | Select-Object -Skip 2
        
        # If no updates available
        if (-not ($updates -match "^\s*\S+\s+\S+")) {
            Write-Host "No updates available." -ForegroundColor Green
            return
        }

        # Format the updates for selection with fzf
        $formattedUpdates = $updates | Where-Object { $_ -match "^\s*\S+\s+\S+" -and $_ -notmatch "^-" -and $_ -notmatch "upgrades available" }
        
        # Exit if no updates are found after formatting
        if (-not $formattedUpdates) {
            Write-Host "No updates available." -ForegroundColor Green
            return
        }

        Write-Host "Select packages to update (use TAB to select multiple, ENTER to confirm):" -ForegroundColor Yellow
        
        # Use fzf for selection with multi-select enabled
        $selectedUpdates = $formattedUpdates | fzf --multi --height 50% --border --header="Select packages to update (TAB to select multiple, ENTER to confirm)"
        
        if (-not $selectedUpdates) {
            Write-Host "No packages selected for update." -ForegroundColor Yellow
            return
        }

        # Extract package IDs from selected updates
        $packageIds = @()
        foreach ($update in $selectedUpdates) {
            if ($update -match "^\s*(\S+)\s+") {
                $packageIds += $matches[1]
            }
        }

        if ($packageIds.Count -eq 0) {
            Write-Host "Failed to parse selected packages." -ForegroundColor Red
            return
        }

        # Update each selected package
        Write-Host "Updating selected packages..." -ForegroundColor Cyan
        foreach ($id in $packageIds) {
            Write-Host "Updating $id..." -ForegroundColor Cyan
            winget upgrade $id
        }

        Write-Host "Update process completed." -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Create alias for Update-SelectedPackages
Set-Alias wup Update-SelectedPackages


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
