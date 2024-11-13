Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
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

    if (-not (Test-Path -Path "$Home\.config")){
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

    # Disable PowerShell 7 telemetry
    [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'Machine')

    # Command to install a nerd font
    oh-my-posh font install

    # Output completion message
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
    Write-Host "  Loaded Owen3456's Profile" -ForegroundColor Green
    Write-Host "  Ensure you are using a Nerd Font (https://www.nerdfonts.com/)" -ForegroundColor Yellow
    Write-Host "  Restart your terminal to apply changes" -ForegroundColor Yellow
    Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
    Write-Host ""
    Write-Host ""
    Write-Host ""

}
catch {
    # Output message with error if install fails
    Write-Error "Failed to install profile. Error: $_"
}