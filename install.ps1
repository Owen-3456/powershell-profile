
Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    # Install required programs in parallel
    $wingetPkgs = @(
        "Microsoft.PowerShell",
        "JanDeDobbeleer.OhMyPosh",
        "ajeetdsouza.zoxide",
        "fzf",
        "Fastfetch-cli.Fastfetch",
        "gerardog.gsudo",
        "sharkdp.bat"
    )
    # Inform user what is being installed
    Write-Host "Installing the following packages via winget:" -ForegroundColor Cyan
    foreach ($pkg in $wingetPkgs) { Write-Host "  - $pkg" -ForegroundColor White }
    $wingetJobs = @()
    foreach ($pkg in $wingetPkgs) {
        $wingetJobs += Start-Job -ScriptBlock { param($p) winget install $p --silent } -ArgumentList $pkg
    }

    # Ensure config directories exist
    $dirs = @("$HOME\Documents\PowerShell", "$HOME\.config\oh-my-posh", "$HOME\.config\fastfetch")
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    }

    # Download files in parallel
    $downloads = @(
        @{Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"; Path = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" },
        @{Url = "https://raw.githubusercontent.com/Owen-3456/dotfiles/refs/heads/main/starship/.config/starship.toml"; Path = "$HOME\.config\starship.toml" },
        @{Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/config.jsonc"; Path = "$HOME\.config\fastfetch\config.jsonc" },
        @{Url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"; Path = "$HOME\Downloads\nerd-font-temp\JetBrainsMono.zip" }
    )
    # Inform user about config downloads
    Write-Host "`nDownloading configuration files:" -ForegroundColor Cyan
    foreach ($dl in $downloads) {
        Write-Host "  - $($dl.Path) from $($dl.Url)" -ForegroundColor White
    }
    $downloadJobs = @()
    foreach ($dl in $downloads) {
        $downloadJobs += Start-Job -ScriptBlock {
            param($u, $p)
            Invoke-WebRequest -Uri $u -OutFile $p -UseBasicParsing
        } -ArgumentList $dl.Url, $dl.Path
    }

    # Install Terminal-Icons in background
    $tiJob = Start-Job -ScriptBlock { Install-Module -Name Terminal-Icons -Repository PSGallery -Force }
    # Inform user about module install
    Write-Host "`nInstalling PowerShell module: Terminal-Icons" -ForegroundColor Cyan

    # Disable PowerShell 7 telemetry
    [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'User')

    # Set PowerShell 7 as default (unchanged logic, but run after installs)
    function Set-PowerShell7Default {
        param ([ValidateSet("PS7", "PS5")][string]$action)
        switch ($action) {
            "PS7" {
                if (-not (Test-Path "$env:ProgramFiles\PowerShell\7")) {
                    Write-Host "Installing Powershell 7..."
                    winget install Microsoft.PowerShell --silent
                }
                $targetTerminalName = "PowerShell"
            }
            "PS5" { $targetTerminalName = "Windows PowerShell" }
        }
        if (-not (Get-Command "wt" -ErrorAction SilentlyContinue)) { return }
        $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        if (-not (Test-Path $settingsPath)) { return }
        $settingsContent = Get-Content -Path $settingsPath | ConvertFrom-Json
        $ps7Profile = $settingsContent.profiles.list | Where-Object { $_.name -eq $targetTerminalName }
        if ($ps7Profile) {
            $settingsContent.defaultProfile = $ps7Profile.guid
            $updatedSettings = $settingsContent | ConvertTo-Json -Depth 100
            Set-Content -Path $settingsPath -Value $updatedSettings
        }
    }

    # Wait for installs and downloads to finish
    Write-Host "Waiting for installs and downloads to complete..." -ForegroundColor Yellow
    $allJobs = $wingetJobs + $downloadJobs + $tiJob
    $null = $allJobs | ForEach-Object { Receive-Job -Job $_ -Wait }
    $allJobs | Remove-Job

    Set-PowerShell7Default -action "PS7"

    # Install nerd font
    $nerdFontZip = "$HOME\Downloads\nerd-font-temp\JetBrainsMono.zip"
    $nerdFontDest = "$HOME\AppData\Local\Microsoft\Windows\Fonts"
    Expand-Archive -Path $nerdFontZip -DestinationPath $nerdFontDest -Force
    Remove-Item -Path "$HOME\Downloads\nerd-font-temp" -Recurse -Force
    Write-Host "Nerd Font installed to $nerdFontDest" -ForegroundColor Green

    # Output completion message
    Write-Host ""
    Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
    Write-Host "  Loaded Owen3456's Profile" -ForegroundColor Green
    Write-Host "  Configure your terminal to use a Nerd Font" -ForegroundColor Yellow
    Write-Host "  Restart your terminal to apply changes" -ForegroundColor Yellow
    Write-Host "-----------------------------------------------------------------" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Error "Failed to install profile. Error: $_"
}