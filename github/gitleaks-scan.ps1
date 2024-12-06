if ($null -eq $env:WORKDIR ) {
  $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
  New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir
# Save as `scan-gitleaks.ps1`
$ClonePath = Join-Path $workdir "cloned-repos"
$ReportPath = Join-Path $workdir "gitleaks-report.json"
$IndividualReportsPath = Join-Path $workdir -ChildPath "gitleaks-reports"

# Ensure the directory for individual reports exists
if (-Not (Test-Path $IndividualReportsPath)) {
  New-Item -ItemType Directory -Path $IndividualReportsPath
}

# Initialize combined report
$CombinedReport = @()

# Scan each repository
Get-ChildItem -Path $ClonePath -Directory | ForEach-Object {
  $RepoName = $_.Name
  $RepoPath = $_.FullName
  $OutputFile = Join-Path $workdir "$RepoName-gitleaks.json"

  Write-Host "Running gitleaks on $RepoName..."
  gitleaks detect --source $RepoPath --report-format json --report-path $OutputFile

  # Parse the individual report
  $Status = if ((Test-Path $OutputFile) -and ((Get-Content $OutputFile).Length -gt 0)) {
    "Findings Detected"
  }
  else {
    "No Findings"
  }

  # Add to combined report
  $CombinedReport += @{
    RepoName       = $RepoName
    GitleaksStatus = $Status
    Findings       = if ($Status -eq "Findings Detected") { Get-Content $OutputFile | ConvertFrom-Json } else { @() }
  }
}

# Save the combined report
$CombinedReport | ConvertTo-Json -Depth 10 | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Gitleaks scan completed. Combined report saved to $ReportPath"
