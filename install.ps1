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

    # Disable PowerShell 7 telemetry
    [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'Machine')

    # Sets P7 as default

    function Set-PowerShell7Default {
        <#
    .SYNOPSIS
        This will edit the config file of the Windows Terminal Replacing the Powershell 5 to Powershell 7 and install Powershell 7 if necessary
    .PARAMETER action
        PS7:           Configures Powershell 7 to be the default Terminal
        PS5:           Configures Powershell 5 to be the default Terminal
    #>
        param (
            [ValidateSet("PS7", "PS5")]
            [string]$action
        )

        switch ($action) {
            "PS7" {
                if (Test-Path -Path "$env:ProgramFiles\PowerShell\7") {
                    Write-Host "Powershell 7 is already installed."
                }
                else {
                    Write-Host "Installing Powershell 7..."
                    Invoke-WinUtilWingetProgram -Action Install -Programs @("Microsoft.PowerShell")
                }
                $targetTerminalName = "PowerShell"
            }
            "PS5" {
                $targetTerminalName = "Windows PowerShell"
            }
        }
        # Check if the Windows Terminal is installed and return if not (Prerequisite for the following code)
        if (-not (Get-Command "wt" -ErrorAction SilentlyContinue)) {
            Write-Host "Windows Terminal not installed. Skipping Terminal preference"
            return
        }
        # Check if the Windows Terminal settings.json file exists and return if not (Prereqisite for the following code)
        $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        if (-not (Test-Path -Path $settingsPath)) {
            Write-Host "Windows Terminal Settings file not found at $settingsPath"
            return
        }

        Write-Host "Settings file found."
        $settingsContent = Get-Content -Path $settingsPath | ConvertFrom-Json
        $ps7Profile = $settingsContent.profiles.list | Where-Object { $_.name -eq $targetTerminalName }
        if ($ps7Profile) {
            $settingsContent.defaultProfile = $ps7Profile.guid
            $updatedSettings = $settingsContent | ConvertTo-Json -Depth 100
            Set-Content -Path $settingsPath -Value $updatedSettings
            Write-Host "Default profile updated to " -NoNewline
            Write-Host "$targetTerminalName " -ForegroundColor White -NoNewline
            Write-Host "using the name attribute."
        }
        else {
            Write-Host "No PowerShell 7 profile found in Windows Terminal settings using the name attribute."
        }
    }

    Set-PowerShell7Default

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