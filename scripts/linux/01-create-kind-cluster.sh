#!/usr/bin/env bash
set -euo pipefail

kind delete cluster --name runtime-security-lab || true
kind create cluster --config kind/kind-cilium.yaml

kubectl cluster-info --context kind-runtime-security-lab
kubectl get nodes -o wide
