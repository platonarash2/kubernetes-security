#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -
PWD="$(kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')"
kubectl -n observability create secret generic quickstart-es-elastic-user \
  --from-literal=elastic="$PWD" \
  --dry-run=client -o yaml | kubectl apply -f -
