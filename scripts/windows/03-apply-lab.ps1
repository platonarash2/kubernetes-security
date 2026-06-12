$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path ".rendered" | Out-Null

$kustomize = Get-Command kustomize -ErrorAction SilentlyContinue
if ($kustomize) {
  kustomize build lab/overlays/kind | Out-File -Encoding utf8 .rendered/lab.yaml
} else {
  kubectl kustomize lab/overlays/kind | Out-File -Encoding utf8 .rendered/lab.yaml
}

kubectl apply -f .rendered/lab.yaml

kubectl -n payments rollout status deployment/payments-api --timeout=180s
kubectl -n attacker rollout status deployment/attacker --timeout=180s

kubectl get pods -A
