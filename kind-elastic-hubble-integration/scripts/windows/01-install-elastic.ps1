$ErrorActionPreference = "Stop"

kubectl apply -f elastic/eck-namespace.yaml

helm repo add elastic https://helm.elastic.co
helm repo update

helm upgrade --install elastic-operator elastic/eck-operator `
  --namespace elastic-system `
  --create-namespace `
  --wait

kubectl apply -f elastic/elastic-stack.yaml

kubectl -n elastic-system wait --for=condition=Ready elasticsearch/quickstart --timeout=600s
kubectl -n elastic-system wait --for=condition=Ready kibana/quickstart --timeout=600s

Write-Host "Elastic password:"
kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
Write-Host ""
