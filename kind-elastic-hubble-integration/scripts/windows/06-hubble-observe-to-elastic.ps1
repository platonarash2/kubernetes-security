param(
  [string]$ElasticUrl = "https://localhost:9200",
  [string]$IndexName = "hubble-flows"
)

$ErrorActionPreference = "Continue"

Write-Host "Requires local Cilium CLI."
Write-Host "Port-forward Elasticsearch in another terminal if needed:"
Write-Host "kubectl -n elastic-system port-forward svc/quickstart-es-http 9200:9200"

$pwd = kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'

Write-Host "Port-forwarding Hubble Relay on localhost:4245..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl -n kube-system port-forward svc/hubble-relay 4245:80"

Start-Sleep -Seconds 5

cilium hubble observe --server localhost:4245 -o json --follow | ForEach-Object {
  $line = $_
  if ($line -and $line.Trim().Length -gt 0) {
    $body = "{ `"index`": { `"_index`": `"$IndexName`" } }`n$line`n"
    Invoke-RestMethod `
      -Method Post `
      -Uri "$ElasticUrl/_bulk" `
      -Headers @{ "Content-Type" = "application/x-ndjson" } `
      -Credential (New-Object System.Management.Automation.PSCredential("elastic", (ConvertTo-SecureString $pwd -AsPlainText -Force))) `
      -Body $body `
      -SkipCertificateCheck | Out-Null
  }
}
