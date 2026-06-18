# kind Filebeat -> Logstash -> Elasticsearch

Pipeline:

```text
/var/log/containers/*.log
        |
        v
Filebeat DaemonSet
        |
        v
Logstash Service :5044
        |
        v
Elasticsearch
```

Use this repo after your kind runtime-security lab and ECK Elasticsearch/Kibana are running.

## Windows quick start

```powershell
.\scripts\windows\01-create-secret.ps1
.\scripts\windows\02-install-pipeline.ps1
.\scripts\windows\03-check-pipeline.ps1
```

Create Kibana data view:

```text
runtime-security-*
```

## Why this design

Filebeat collects logs from every kind node. Logstash parses and normalizes the raw JSON inside the log message so ES|QL can query fields such as:

- `event.source`
- `event.action`
- `event.type`
- `process.executable`
- `file.path`
- `policy.name`
- `runtime_kubernetes.pod.name`
- `runtime_kubernetes.namespace`
