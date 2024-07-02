Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    # Installs required programs
    winget install Microsoft.PowerShell JanDeDobbeleer.OhMyPosh ajeetdsouza.zoxide fzf Fastfetch-cli.Fastfetch gerardog.gsudo

    # Downloads profile and saves to file path
    $profile_Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $profile_Path = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    if (-not (Test-Path -Path $profile_Path)) {
        New-Item -ItemType File -Path $profile_Path -Force | Out-Null
    }
    Invoke-WebRequest -Uri $profile_Url -OutFile $profile_Path

    # Download Oh My Posh config and saves to file path
    $ohMyPosh_Config_Url = ""
    $ohMyPosh_Config_Path = "$HOME\.oh-my-posh\nordcustom.omp.json"
    if (-not (Test-Path -Path $ohMyPosh_Config_Path)) {
        $ohMyPosh_Config_Path_Path = Split-Path -Path $ohMyPosh_Config_Path -Parent
        if (-not (Test-Path -Path $ohMyPosh_Config_Path_Path)) {
            New-Item -ItemType Directory -Path $ohMyPosh_Config_Path_Path | Out-Null
        }
        New-Item -ItemType File -Path $ohMyPosh_Config_Dir -Force | Out-Null
    }
    Invoke-WebRequest -Uri $ohMyPosh_Config_Url -OutFile $ohMyPosh_Config_Path
    
    # Downloads fastfetch config and saves to file path
    $fastfetch_Config_Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"
    $fastfetch_Config_Path = "$HOME\fastfetch\config.jsonc"
    if (-not (Test-Path -Path $fastfetch_Config_Path)) {
        $fastfetch_Directory_Path = Split-Path -Path $fastfetch_Config_Path -Parent
        if (-not (Test-Path -Path $fastfetch_Directory_Path)) {
            New-Item -ItemType Directory -Path $fastfetch_Directory_Path | Out-Null
        }
        New-Item -ItemType File -Path $fastfetch_Config_Path | Out-Null
    }
    Invoke-WebRequest -Uri $fastfetch_Config_Url -OutFile $fastfetch_Config_Path

    # Output completion message
    Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
}
catch {
    # Output message with error if install fails
    Write-Error "Failed to install profile. Error: $_"
}