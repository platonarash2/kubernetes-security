# kind Elastic + Hubble + KubeArmor Integration

Add-on repo for your kind runtime security lab.

Installs/configures:

- Elasticsearch + Kibana through ECK
- Hubble Relay + Hubble UI by upgrading Cilium
- Fluent Bit to ship KubeArmor, Tetragon and Cilium pod logs to Elasticsearch
- Optional local Hubble -> Elasticsearch bridge script

## Quick start - Windows PowerShell

Use **PowerShell as Administrator**.

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


```powershell
.\scripts\windows\01-install-elastic.ps1
.\scripts\windows\02-enable-hubble.ps1
.\scripts\windows\03-install-fluentbit.ps1
.\scripts\windows\04-port-forward-kibana.ps1
```

## Kibana

URL:

```text
https://localhost:5601
```

Username:

```text
elastic
```

Password:

```powershell
kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
```

## Data views in Kibana

Create:

```text
runtime-security-*
hubble-flows
```



