$profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
$profilePath = "$HOME\Documents\PowerShell"
Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath