$ErrorActionPreference = "Stop"

Write-Host "Checking tools..."

$tools = @(
  @{Name="kubectl"; Winget="Kubernetes.kubectl"},
  @{Name="helm"; Winget="Helm.Helm"},
  @{Name="kind"; Winget="Kubernetes.kind"},
  @{Name="git"; Winget="Git.Git"}
)

foreach ($tool in $tools) {
  $cmd = Get-Command $tool.Name -ErrorAction SilentlyContinue
  if (-not $cmd) {
    Write-Host "Installing $($tool.Name) with winget..."
    winget install --id $tool.Winget -e --accept-package-agreements --accept-source-agreements
  } else {
    Write-Host "$($tool.Name) found: $($cmd.Source)"
  }
}

Write-Host "Verify Docker Desktop is installed and running:"
docker version

Write-Host "Tool versions:"
kubectl version --client
helm version
kind version
