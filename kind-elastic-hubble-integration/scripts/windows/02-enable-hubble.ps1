$ErrorActionPreference = "Stop"

helm repo add cilium https://helm.cilium.io/
helm repo update

helm upgrade cilium cilium/cilium `
  --namespace kube-system `
  --reuse-values `
  --set hubble.enabled=true `
  --set hubble.relay.enabled=true `
  --set hubble.ui.enabled=true `
  --wait

kubectl -n kube-system rollout status ds/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/hubble-relay --timeout=300s
kubectl -n kube-system rollout status deployment/hubble-ui --timeout=300s

kubectl -n kube-system get pods | findstr hubble
