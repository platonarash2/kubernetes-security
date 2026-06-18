#!/usr/bin/env bash
set -euo pipefail

kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

PWD_B64="$(kubectl -n elastic-system get secret quickstart-es-elastic-user -o jsonpath='{.data.elastic}')"
PWD="$(echo "$PWD_B64" | base64 -d)"

kubectl -n observability create secret generic quickstart-es-elastic-user \
  --from-literal=elastic="$PWD" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -k fluent-bit
kubectl -n observability rollout status ds/fluent-bit --timeout=300s
