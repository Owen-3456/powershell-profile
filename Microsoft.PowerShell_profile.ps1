$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

function Update-PowerShell {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    } else {
        Write-Host "Loading Owen3456's Profile" -ForegroundColor Cyan
        $profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $profilePath = "$HOME\Documents\PowerShell"
        Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
        Write-Host "Loaded Owen3456's Profile" -ForegroundColor Green


    }
}

Update-PowerShell

function ReloadProfile {
    . $PROFILE
}

function Update-Profile {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping profile update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    } else {
        Write-Host "Grabbing Owen3456's profile from GitHub" -ForegroundColor Cyan
        $profileUrl = "https://raw.githubusercontent.com/Owen-3456/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $profilePath = "$HOME\Documents\PowerShell"
        Invoke-WebRequest -Uri $profileUrl -OutFile $profilePath
        Write-Host "Loaded latest version" -ForegroundColor Green
        Write-Host "Reloading profile" -ForegroundColor Cyan
        ReloadProfile
        Write-Host "Profile reloaded" -ForegroundColor Green
    }

}


function hb {
 if ($args.Length -eq 0) {
 Write-Error "No file path specified."
 return
 }

 $FilePath = $args[0]

 if (Test-Path $FilePath) {
 $Content = Get-Content $FilePath -Raw
 } else {
 Write-Error "File path does not exist."
 return
 }

 $uri = "http://bin.christitus.com/documents"
 try {
 $response = Invoke-RestMethod -Uri $uri -Method Post -Body $Content -ErrorAction Stop
 $hasteKey = $response.key
 $url = "http://bin.christitus.com/$hasteKey"
 Write-Output $url
 } catch {
 Write-Error "Failed to upload the document. Error: $_"
 }
}

function ip {
 (Invoke-WebRequest 'http://ifconfig.me/ip').Content
}

function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\pwsh.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\pwsh.exe" -Verb runAs
    }
}

Set-Alias sudo admin

function Edit-Profile
{
    code $PROFILE
    # Change code to your editor of choice (e.g. notepad $PROFILE) 
}

function ll { Get-ChildItem -Path $pwd -File }

function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}

Set-Alias ff find-file

function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}

function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name='LastBootUpTime'; Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
    } else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

function reload {
        & $profile
        Write-Host "Profile reloaded."
}

function winutil {
    Start-Process powershell.exe -verb runas -ArgumentList 'irm https://christitus.com/win | iex'
}

function mas {
    Start-Process powershell.exe -verb runas -ArgumentList 'irm https://massgrave.dev/get | iex'
}

function Clear-History {
    Remove-Item (Get-PSReadlineOption).HistorySavePath
}

# MARK: Location Shortcuts

function doc { Set-Location -Path $HOME\Documents }

function dl { Set-Location -Path $HOME\Downloads }

function gh { Set-Location -Path $HOME\Documents\GitHub }

function c { Set-Location -Path C:\ }
