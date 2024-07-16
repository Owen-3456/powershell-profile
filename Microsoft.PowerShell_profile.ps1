# Checks connection to GitHub
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Checks for PowerShell updates and installs them if needed
function Update-PowerShell {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    }

    try {
        Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
        
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        $currentVersion = $PSVersionTable.PSVersion

        # Convert version strings to Version objects for accurate comparison
        $latestVersionObj = [Version]$latestVersion
        $currentVersionObj = [Version]$currentVersion.ToString()

        if ($currentVersionObj -lt $latestVersionObj) {
            Write-Host "A new PowerShell version ($latestVersion) is available. Updating..." -ForegroundColor Yellow
            $wingetOutput = winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
            if ($wingetOutput -match "No applicable update found.") {
                Write-Host "No applicable update found. Your PowerShell might be up to date or check your winget sources." -ForegroundColor Yellow
            }
            else {
                Write-Host "PowerShell has been updated to version $latestVersion. Please restart your shell to reflect changes." -ForegroundColor Magenta
            }
        }
        else {
            Write-Host "Your PowerShell ($currentVersion) is up to date." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to update PowerShell. Error: $_"
    }
}

# Runs the Update-PowerShell function on startup
Update-PowerShell

# Reloads the profile
function ReloadProfile {
    . $PROFILE
}

function Update-Profile {
    # Check connectivity to both sources before attempting updates
    $canConnectToWebsite = Test-Connection owen3456.xyz -Count 1 -Quiet -TimeoutSeconds 1

    if (-not $canConnectToWebsite -and -not $canConnectToGitHub) {
        Write-Error "Failed to update profile. Unable to connect to both owen3456.xyz and GitHub."
        return
    }

    $updateUrls = @()
    if ($canConnectToWebsite) {
        $updateUrls += "https://owen3456.xyz/pwsh"
    }
    if ($canConnectToGitHub) {
        $updateUrls += "https://raw.githubusercontent.com/owen3456/pwsh/main/Microsoft.PowerShell_profile.ps1"
    }

    foreach ($url in $updateUrls) {
        try {
            Write-Host "Attempting to update profile from $url" -ForegroundColor Cyan
            
            # Securely fetching the script content
            $scriptContent = Invoke-RestMethod -Uri $url -UseBasicParsing

            # Consider validating the script content here for security
            
            # Execute the script content
            Invoke-Expression $scriptContent

            Write-Host "Profile updated successfully from $url." -ForegroundColor Green
            # Reload the profile
            . $PROFILE
            return # Exit after the first successful update
        }
        catch {
            Write-Error "Failed to update profile from $url. Error: $_"
        }
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

function Get-PublicIP {
    try {
        $response = Invoke-RestMethod -Uri 'https://ifconfig.me/ip' -TimeoutSec 5 -ErrorAction Stop
        Write-Output "Your public IP address is: $response"
    }
    catch {
        Write-Error "Failed to retrieve public IP address. Error: $_"
    }
}

Set-Alias ip Get-PublicIP

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
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
    }
    else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
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

# Runs fastfetch if installed

if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}

# Set the prompt to use oh-my-posh
oh-my-posh init pwsh --config "$HOME/.oh-my-posh/nordcustom.omp.json" | Invoke-Expression

# Set up zoxide
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

# Import Terminal-Icons module
Import-Module -Name Terminal-Icons