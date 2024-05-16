Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
$profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
$profilePath = "$HOME\Documents\PowerShell"
Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green
