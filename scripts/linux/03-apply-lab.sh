#!/usr/bin/env bash
set -euo pipefail

mkdir -p .rendered

if command -v kustomize >/dev/null 2>&1; then
  kustomize build lab/overlays/kind > .rendered/lab.yaml
else
  kubectl kustomize lab/overlays/kind > .rendered/lab.yaml
fi

kubectl apply -f .rendered/lab.yaml

kubectl -n payments rollout status deployment/payments-api --timeout=180s
kubectl -n attacker rollout status deployment/attacker --timeout=180s

kubectl get pods -A | egrep 'payments|attacker|cilium|kyverno|tetragon|kubearmor' || true
