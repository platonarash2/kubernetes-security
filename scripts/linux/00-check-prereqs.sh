#!/usr/bin/env bash
set -euo pipefail

for cmd in docker kind kubectl helm; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd"
    exit 1
  fi
done

if command -v kustomize >/dev/null 2>&1; then
  echo "kustomize found"
else
  echo "standalone kustomize not found; will use kubectl kustomize"
fi

docker version
kind version
kubectl version --client
helm version
