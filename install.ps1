
Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    # Check and install/update required programs
    $wingetPkgs = @(
        "Microsoft.PowerShell",
        "JanDeDobbeleer.OhMyPosh",
        "ajeetdsouza.zoxide",
        "fzf",
        "Fastfetch-cli.Fastfetch",
        "gerardog.gsudo",
        "sharkdp.bat"
    )
    
    Write-Host "Checking winget packages..." -ForegroundColor Cyan
    $wingetJobs = @()
    foreach ($pkg in $wingetPkgs) {
        $wingetJobs += Start-Job -ScriptBlock { 
            param($p)
            # Check if package is installed
            $installed = winget list --id $p --exact --disable-interactivity 2>$null
            if ($LASTEXITCODE -eq 0 -and $installed -match $p) {
                Write-Output "Updating $p..."
                winget upgrade $p --silent --accept-source-agreements --accept-package-agreements --source winget --disable-interactivity 2>$null
            }
            else {
                Write-Output "Installing $p..."
                winget install $p --silent --accept-source-agreements --accept-package-agreements --source winget --disable-interactivity 2>$null
            }
        } -ArgumentList $pkg
    }

    # Ensure config directories exist
    $dirs = @("$HOME\Documents\PowerShell", "$HOME\.config\oh-my-posh", "$HOME\.config\fastfetch", "$HOME\Downloads\nerd-font-temp")
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    }

    # Check if font is already installed to skip download if not needed
    $nerdFontCheck = "$HOME\AppData\Local\Microsoft\Windows\Fonts\JetBrainsMonoNerdFont-Regular.ttf"
    $skipFontDownload = Test-Path $nerdFontCheck

    # Download files in parallel (skip font if already installed)
    $downloads = @(
        @{Url = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"; Path = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" },
        @{Url = "https://raw.githubusercontent.com/Owen-3456/dotfiles/refs/heads/main/starship/.config/starship.toml"; Path = "$HOME\.config\starship.toml" },
        @{Url = "https://raw.githubusercontent.com/Owen-3456/dotfiles/refs/heads/main/fastfetch/.config/fastfetch/config.jsonc"; Path = "$HOME\.config\fastfetch\config.jsonc" }
    )
    
    # Add font download only if needed
    if (-not $skipFontDownload) {
        $downloads += @{Url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"; Path = "$HOME\Downloads\nerd-font-temp\JetBrainsMono.zip" }
    }
    
    # Inform user about config downloads
    Write-Host "`nDownloading configuration files:" -ForegroundColor Cyan
    if ($skipFontDownload) {
        Write-Host "  (Skipping font download - already installed)" -ForegroundColor Yellow
    }
    foreach ($dl in $downloads) {
        Write-Host "  - $($dl.Path)" -ForegroundColor White
    }
    $downloadJobs = @()
    foreach ($dl in $downloads) {
        $downloadJobs += Start-Job -ScriptBlock {
            param($u, $p)
            Invoke-WebRequest -Uri $u -OutFile $p -UseBasicParsing
        } -ArgumentList $dl.Url, $dl.Path
    }

    # Check if Terminal-Icons is already installed before attempting install
    $tiJob = $null
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
        $tiJob = Start-Job -ScriptBlock { Install-Module -Name Terminal-Icons -Repository PSGallery -Force -AllowClobber -Scope CurrentUser }
        Write-Host "`nInstalling PowerShell module: Terminal-Icons" -ForegroundColor Cyan
    }
    else {
        Write-Host "`nTerminal-Icons module already installed" -ForegroundColor Yellow
    }

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
    $allJobs = $wingetJobs + $downloadJobs
    if ($tiJob) { $allJobs += $tiJob }
    $null = $allJobs | ForEach-Object { Receive-Job -Job $_ -Wait }
    $allJobs | Remove-Job

    Set-PowerShell7Default -action "PS7"

    # Install nerd font (only if not already installed)
    if ($skipFontDownload) {
        Write-Host "JetBrainsMono Nerd Font is already installed, skipping..." -ForegroundColor Yellow
    }
    else {
        $nerdFontZip = "$HOME\Downloads\nerd-font-temp\JetBrainsMono.zip"
        $nerdFontDest = "$HOME\AppData\Local\Microsoft\Windows\Fonts"
        
        if (Test-Path $nerdFontZip) {
            Write-Host "Installing JetBrainsMono Nerd Font..." -ForegroundColor Cyan
            Expand-Archive -Path $nerdFontZip -DestinationPath $nerdFontDest -Force
            Write-Host "Nerd Font installed to $nerdFontDest" -ForegroundColor Green
        }
        else {
            Write-Host "Font zip file not found, skipping font installation..." -ForegroundColor Yellow
        }
    }
    
    # Clean up temp directory (with error handling for locked files)
    if (Test-Path "$HOME\Downloads\nerd-font-temp") {
        try {
            Remove-Item -Path "$HOME\Downloads\nerd-font-temp" -Recurse -Force -ErrorAction Stop
        }
        catch {
            Write-Host "Note: Could not remove temporary font folder (files may be in use). You can safely delete it manually later." -ForegroundColor Yellow
        }
    }

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