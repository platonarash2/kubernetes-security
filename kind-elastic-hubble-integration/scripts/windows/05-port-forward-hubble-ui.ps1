$ErrorActionPreference = "Continue"

Write-Host "Hubble UI: http://localhost:12000"
kubectl -n kube-system port-forward svc/hubble-ui 12000:80
