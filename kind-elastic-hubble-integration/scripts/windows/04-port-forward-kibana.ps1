$ErrorActionPreference = "Continue"

Write-Host "Kibana: https://localhost:5601"
Write-Host "Username: elastic"
Write-Host "Password:"
kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
Write-Host ""

kubectl -n elastic-system port-forward svc/quickstart-kb-http 5601:5601
