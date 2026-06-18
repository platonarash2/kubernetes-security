#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f elastic/eck-namespace.yaml

helm repo add elastic https://helm.elastic.co >/dev/null
helm repo update >/dev/null

helm upgrade --install elastic-operator elastic/eck-operator \
  --namespace elastic-system \
  --create-namespace \
  --wait

kubectl apply -f elastic/elastic-stack.yaml

kubectl -n elastic-system wait --for=condition=Ready elasticsearch/quickstart --timeout=600s
kubectl -n elastic-system wait --for=condition=Ready kibana/quickstart --timeout=600s

echo "Elastic password:"
kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
echo
