# Windows 11 setup for kind Runtime Security Lab

## 1. Enable WSL2

PowerShell as Administrator:

```powershell
wsl --install
wsl --set-default-version 2
```

Reboot if requested.

## 2. Install Docker Desktop

Install Docker Desktop for Windows and enable:

- Use WSL 2 based engine
- Kubernetes is not required for this lab
- Ensure Docker works:

```powershell
docker version
docker run hello-world
```

## 3. Install tools with winget

```powershell
winget install Kubernetes.kubectl
winget install Helm.Helm
winget install Kubernetes.kind
winget install Git.Git
```

Kustomize is included in recent `kubectl` as:

```powershell
kubectl kustomize --help
```

The scripts use standalone `kustomize` if available, otherwise `kubectl kustomize`.

## 4. Verify

```powershell
kubectl version --client
helm version
kind version
docker version
```

## 5. Create the lab

```powershell
.\scripts\windows\01-create-kind-cluster.ps1
```

## 6. Install platform stack

```powershell
.\scripts\windows\02-install-platform.ps1
```

## 7. Apply lab workloads and policies

```powershell
.\scripts\windows\03-apply-lab.ps1
```

## 8. Run tests

```powershell
.\scripts\windows\04-run-tests.ps1
```

## Notes

- AppArmor behavior depends on the Linux kernel and the containerized kind node image.
- SELinux is not part of this lab.
- This lab is intended for policy behavior, runtime events and local testing.
