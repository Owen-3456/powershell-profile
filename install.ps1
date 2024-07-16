Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan

# Function to download and save a file if it doesn't already exist
function Get-File {
    param (
        [string]$Url,
        [string]$Path
    )
    $parentPath = Split-Path -Path $Path -Parent
    if (-not (Test-Path -Path $parentPath)) {
        New-Item -ItemType Directory -Path $parentPath | Out-Null
    }
    if (-not (Test-Path -Path $Path)) {
        Invoke-RestMethod -Uri $Url -OutFile $Path
    }
}

try {
    # Check for winget availability
    if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
        # Download and install winget
        $wingetInstallerUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/winget-cli-msixbundle.msixbundle"
        $wingetInstallerPath = "$env:TEMP\winget-cli.msixbundle"
        Get-File -Url $wingetInstallerUrl -Path $wingetInstallerPath
        Start-Process -Wait -FilePath "msixbundle" -ArgumentList "/i", $wingetInstallerPath
    }

    # Install required programs using winget
    winget install Microsoft.PowerShell JanDeDobbeleer.OhMyPosh ajeetdsouza.zoxide fzf Fastfetch-cli.Fastfetch gerardog.gsudo
    
    # Define files to download
    $filesToDownload = @(
        @{
            Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
            Path = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        },
        @{
            Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/nordcustom.omp.json"
            Path = "$HOME\.oh-my-posh\nordcustom.omp.json"
        },
        @{
            Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"
            Path = "$HOME\fastfetch\config.jsonc"
        }
    )

    # Download and save each file
    foreach ($file in $filesToDownload) {
        Get-File -Url $file.Url -Path $file.Path
    }

    # Install Terminal-Icons if not already installed
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
        Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser
    }

    # Output completion message
    Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
    Write-Host "Please ensure you are using a Nerd Font (https://www.nerdfonts.com/) for the best experience" -ForegroundColor Yellow
}
catch {
    # Output message with error if install fails
    Write-Error "Failed to install profile. Error: $_"
}