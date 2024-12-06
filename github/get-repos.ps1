if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir


# Save as `list-repos.ps1`
$OrgName = "nexi-intra"
$OutputFile = Join-Path $workdir "repos.txt"

# Ensure GitHub CLI is authenticated
gh auth status

# Fetch repositories and save to repos.txt
gh repo list $OrgName --limit 1000 --json nameWithOwner | ConvertFrom-Json | ForEach-Object {
  $_.nameWithOwner
} | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Repositories saved to $OutputFile"
