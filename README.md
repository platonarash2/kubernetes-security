# kind Runtime Security Lab

This lab runs on **kind** on Windows 11 with Docker Desktop as the container backend.

It installs:

- Cilium as CNI
- Kyverno
- KubeArmor
- Tetragon
- Seccomp RuntimeDefault examples
- AppArmor guidance/examples where supported

## Why kind?

Docker Desktop built-in Kubernetes is not ideal for Cilium because Cilium should be installed as the CNI from cluster bootstrap. kind allows us to create a cluster with `disableDefaultCNI: true`.

## Quick start on Windows 11

Use **PowerShell as Administrator**.

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Applicera labbens konfig igen:
kubectl apply -k .\lab\overlays\kind

```powershell
.\scripts\windows\00-install-tools.ps1
.\scripts\windows\01-create-kind-cluster.ps1
.\scripts\windows\02-install-platform.ps1
.\scripts\windows\03-apply-lab.ps1
.\scripts\windows\04-run-tests.ps1
```

Alternative using WSL2/Linux shell:

```bash
./scripts/linux/00-check-prereqs.sh
./scripts/linux/01-create-kind-cluster.sh
./scripts/linux/02-install-platform.sh
./scripts/linux/03-apply-lab.sh
./scripts/linux/04-run-tests.sh
```

## Azure DevOps

Use a **self-hosted Azure DevOps agent** on the Windows 11 machine. Microsoft-hosted agents cannot access your local Docker Desktop/kind cluster.

Pipeline entrypoint:

```text
azure-pipelines.yml
```

## Components

```text
kind
  -> local Kubernetes

Cilium
  -> CNI + NetworkPolicy

Kyverno
  -> admission/governance

KubeArmor
  -> runtime enforcement

Tetragon
  -> runtime detection

Seccomp
  -> syscall baseline

AppArmor
  -> supported only if node/kernel exposes it
```
