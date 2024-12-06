if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir

# Save as `make-repos-private.ps1`

# Path to the repos.txt file
$RepoFile = Join-Path $workdir  "repos-makeprivate.txt"

# Check if GitHub CLI is installed
if (-Not (Get-Command "gh" -ErrorAction SilentlyContinue)) {
  Write-Error "GitHub CLI (gh) is not installed. Please install it and run the script again."
  return
}

# Authenticate with GitHub CLI
Write-Host "Checking GitHub CLI authentication..."
gh auth status
if ($LASTEXITCODE -ne 0) {
  Write-Error "GitHub CLI is not authenticated. Please authenticate using 'gh auth login' and try again."
  return
}

# Read the repository list and process each
if (Test-Path $RepoFile) {
  Get-Content -Path $RepoFile | ForEach-Object {
    $Repo = $_.Trim()
    if (-Not $Repo) { return }

    Write-Host "Checking repository: $Repo..."

    # Get repository details
    $RepoDetails = gh repo view $Repo --json visibility | ConvertFrom-Json
    if ($RepoDetails.visibility -eq "private") {
      Write-Host "$Repo is already private."
    }
    else {
      Write-Host "$Repo is public. Making it private..."
      gh repo edit $Repo --visibility private
      if ($LASTEXITCODE -eq 0) {
        Write-Host "$Repo has been made private."
      }
      else {
        Write-Error "Failed to make $Repo private."
      }
    }
  }
}
else {
  Write-Error "repos.txt not found in the workdir directory ($workdir)."
}
