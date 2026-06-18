$ErrorActionPreference = "Stop"

kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

$pwdB64 = kubectl -n elastic-system get secret quickstart-es-elastic-user -o jsonpath='{.data.elastic}'
$pwd = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($pwdB64))

kubectl -n observability create secret generic quickstart-es-elastic-user `
  --from-literal=elastic=$pwd `
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -k fluent-bit

kubectl -n observability rollout status ds/fluent-bit --timeout=300s
kubectl -n observability get pods -o wide
