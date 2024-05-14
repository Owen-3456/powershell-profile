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
 curl "api.ipify.org"
}

function weather {
 curl "wttr.in"
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