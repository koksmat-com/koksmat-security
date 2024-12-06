if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir
# Save as `clone-repos.ps1`
$RepoFile = Join-Path $workdir "clone-repos.txt"
$ClonePath = Join-Path $workdir  "cloned-repos"

# Ensure the directory for cloned repos exists
if (-Not (Test-Path $ClonePath)) {
  New-Item -ItemType Directory -Path $ClonePath
}

# Clone each repository
Get-Content -Path $RepoFile | ForEach-Object {
  $RepoName = $_.Trim()
  Write-Host "Cloning $RepoName..."
  gh repo clone $RepoName (Join-Path -Path $ClonePath -ChildPath $RepoName.Split('/')[-1])
}

Write-Host "All repositories cloned to $ClonePath"
