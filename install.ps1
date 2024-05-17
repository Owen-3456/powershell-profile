Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
try {
    winget install Microsoft.PowerShell --silent
    winget install JanDeDobbeleer.OhMyPosh -s winget
    $profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $profilePath = "$HOME\Documents\PowerShell"
    Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
    Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
} catch {
    Write-Error "Failed to install profile. Error: $_"
}