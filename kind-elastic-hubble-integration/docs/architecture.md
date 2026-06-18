# Architecture

```text
KubeArmor/Tetragon/Cilium pod logs
        |
        v
Fluent Bit DaemonSet
        |
        v
Elasticsearch: runtime-security-*

Cilium
        |
        v
Hubble Relay + Hubble UI

Optional:
Cilium CLI / Hubble observe
        |
        v
PowerShell bridge
        |
        v
Elasticsearch: hubble-flows
```

## Note about Hubble

Hubble flows are not normal Kubernetes pod logs. The repo enables Hubble UI and includes a local bridge script for pushing `hubble observe -o json` into Elasticsearch.
