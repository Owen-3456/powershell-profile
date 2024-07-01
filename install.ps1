Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    # Installs required programs
    winget install Microsoft.PowerShell JanDeDobbeleer.OhMyPosh ajeetdsouza.zoxide fzf Fastfetch-cli.Fastfetch gerardog.gsudo

    # Downloads profile and saves to file path
    $profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $profilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    if (-not (Test-Path -Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
    }
    Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
    
    # Downloads fastfetch config and saves to file path
    $fastfetchconfigUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"
    $fastfetchconfigPath = "$HOME\fastfetch\config.jsonc"
    if (-not (Test-Path -Path $fastfetchconfigPath)) {
        New-Item -ItemType File -Path $fastfetchconfigPath | Out-Null
    }
    Invoke-WebRequest -Uri $fastfetchconfigUrl -OutFile $fastfetchconfigPath

    # Output completion message
    Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
}
catch {
    # Output message with error if install fails
    Write-Error "Failed to install profile. Error: $_"
}