# Save as `check-install-gitleaks.ps1`

function Install-Gitleaks {
  Write-Host "Installing gitleaks..."

  if ($IsWindows) {
    # Windows Installation
    if (-Not (Get-Command "choco" -ErrorAction SilentlyContinue)) {
      Write-Error "Chocolatey is not installed. Please install Chocolatey and run the script again."
      return
    }
    choco install gitleaks -y
  }
  elseif ($IsMacOS) {
    # macOS Installation
    if (-Not (Get-Command "brew" -ErrorAction SilentlyContinue)) {
      Write-Error "Homebrew is not installed. Please install Homebrew and run the script again."
      return
    }
    brew install gitleaks
  }
  else {
    Write-Error "Unsupported operating system. Please install gitleaks manually."
  }

  Write-Host "Gitleaks installation completed."
}

# Check if Gitleaks is installed
function Check-Gitleaks {
  if (Get-Command "gitleaks" -ErrorAction SilentlyContinue) {
    Write-Host "Gitleaks is already installed."
    return $true
  }
  else {
    Write-Host "Gitleaks is not installed."
    return $false
  }
}

# Determine OS
#$IsWindows = $PSVersionTable.PSCompatibleVersions -match '5.*' -or $env:OS -eq "Windows_NT"
#$IsMacOS = $env:OSTYPE -like "*darwin*"

# Main Logic
if (-Not (Check-Gitleaks)) {
  Install-Gitleaks
}
