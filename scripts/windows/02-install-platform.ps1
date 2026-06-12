$ErrorActionPreference = "Stop"


kubectl create namespace kubearmor --dry-run=client -o yaml | kubectl apply -f -
kubectl label ns kubearmor pod-security.kubernetes.io/enforce=privileged --overwrite
kubectl label ns kubearmor pod-security.kubernetes.io/audit=privileged --overwrite
kubectl label ns kubearmor pod-security.kubernetes.io/warn=privileged --overwrite

kubectl create namespace tetragon --dry-run=client -o yaml | kubectl apply -f -
kubectl label ns tetragon pod-security.kubernetes.io/enforce=privileged --overwrite
kubectl label ns tetragon pod-security.kubernetes.io/audit=privileged --overwrite
kubectl label ns tetragon pod-security.kubernetes.io/warn=privileged --overwrite



Write-Host "Installing Cilium..."
helm repo add cilium https://helm.cilium.io/
helm repo update

helm upgrade --install cilium cilium/cilium `
  --namespace kube-system `
  --set ipam.mode=kubernetes `
  --set kubeProxyReplacement=true `
  --set securityContext.privileged=true `
  --wait

kubectl -n kube-system rollout status ds/cilium --timeout=300s
kubectl get nodes

Write-Host "Installing Kyverno..."
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm upgrade --install kyverno kyverno/kyverno `
  --namespace kyverno `
  --create-namespace `
  --wait

Write-Host "Installing Tetragon..."
helm upgrade --install tetragon cilium/tetragon `
  --namespace tetragon `
  --create-namespace `
  --wait

Write-Host "Installing KubeArmor operator..."
helm repo add kubearmor https://kubearmor.github.io/charts
helm repo update

helm upgrade --install kubearmor kubearmor/kubearmor `
  --namespace kubearmor `
  --create-namespace `
  --wait
  

kubectl get pods -A
