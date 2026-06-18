$ErrorActionPreference = "Stop"

kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

$pwd = kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'

kubectl -n observability create secret generic quickstart-es-elastic-user `
  --from-literal=elastic=$pwd `
  --dry-run=client -o yaml | kubectl apply -f -

kubectl -n observability get secret quickstart-es-elastic-user
