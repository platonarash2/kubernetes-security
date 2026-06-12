#!/usr/bin/env bash
set -euo pipefail

echo "Installing Cilium as CNI..."
helm repo add cilium https://helm.cilium.io/ >/dev/null
helm repo update >/dev/null

helm upgrade --install cilium cilium/cilium \
  --namespace kube-system \
  --set ipam.mode=kubernetes \
  --set kubeProxyReplacement=true \
  --set securityContext.privileged=true \
  --wait

kubectl -n kube-system rollout status ds/cilium --timeout=300s
kubectl get nodes

echo "Installing Kyverno..."
helm repo add kyverno https://kyverno.github.io/kyverno/ >/dev/null
helm repo update >/dev/null
helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --wait

echo "Installing Tetragon..."
helm upgrade --install tetragon cilium/tetragon \
  --namespace tetragon \
  --create-namespace \
  --wait

echo "Installing KubeArmor ..."
helm upgrade --install kubearmor kubearmor/kubearmor `
  --namespace kubearmor `
  --create-namespace `
  --wait
  
# helm repo add kubearmor https://kubearmor.github.io/charts >/dev/null
# helm repo update >/dev/null
# helm upgrade --install kubearmor-operator kubearmor/kubearmor-operator \
  # --namespace kubearmor \
  # --create-namespace \
  # --wait || true

kubectl apply -f platform/kubearmor/kubearmor-config.yaml || true

kubectl get pods -A | egrep 'cilium|kyverno|tetragon|kubearmor' || true
