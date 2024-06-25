Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    # Install PowerShell 7
    winget install Microsoft.PowerShell --silent

    # Install OhMyPosh
    winget install JanDeDobbeleer.OhMyPosh -s winget

    # Install Zoxide
    winget install ajeetdsouza.zoxide

    # Install Fzf
    winget install fzf

    # Install fastfetch
    winget install Fastfetch-cli.Fastfetch

    # Set profile location to variable
    $profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"

    # Set file path to variable
    $profilePath = "$HOME\Documents\PowerShell"

    # Download the profile and save to file path
    Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
    
    # Set the fastfetch config profile location to variable
    $fastfetchconfigUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"

    # Sets fastfetch config file path to variable
    $fastfetchconfigPath = "$HOME\fastfetch"

    # Download the fastfetch config and save to file path
    Invoke-WebRequest -Uri $fastfetchconfigUrl -OutFile $fastfetchconfigPath

    # Output completion message
    Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
} catch {
    # Output message with error if install fails
    Write-Error "Failed to install profile. Error: $_"
}