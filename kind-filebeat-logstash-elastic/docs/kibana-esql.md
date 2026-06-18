# ES|QL examples

## Latest normalized events

```esql
FROM runtime-security-*
| WHERE @timestamp >= NOW() - 5 MINUTES
| SORT @timestamp DESC
| KEEP @timestamp, event.source, event.type, event.action, kubernetes.namespace, kubernetes.pod.name, runtime_kubernetes.namespace, runtime_kubernetes.pod.name, process.executable, process.command_line, file.path, policy.name
```

## ServiceAccount token access

```esql
FROM runtime-security-*
| WHERE @timestamp >= NOW() - 15 MINUTES
| WHERE file.path == "/var/run/secrets/kubernetes.io/serviceaccount/token" OR message LIKE "*serviceaccount/token*"
| SORT @timestamp DESC
| KEEP @timestamp, event.source, event.type, event.action, kubernetes.namespace, kubernetes.pod.name, runtime_kubernetes.namespace, runtime_kubernetes.pod.name, process.executable, file.path, policy.name
```

## Tetragon process exec

```esql
FROM runtime-security-*
| WHERE @timestamp >= NOW() - 15 MINUTES
| WHERE event.source == "tetragon" AND event.type == "process_exec"
| SORT @timestamp DESC
| KEEP @timestamp, runtime_kubernetes.namespace, runtime_kubernetes.pod.name, process.executable, process.command_line, process.parent.executable
```

## KubeArmor policy events

```esql
FROM runtime-security-*
| WHERE @timestamp >= NOW() - 15 MINUTES
| WHERE event.source == "kubearmor"
| SORT @timestamp DESC
| KEEP @timestamp, event.action, policy.name, runtime_kubernetes.namespace, runtime_kubernetes.pod.name, process.executable, file.path, message
```

## Attacker timeline

```esql
FROM runtime-security-*
| WHERE @timestamp >= NOW() - 15 MINUTES
| WHERE kubernetes.pod.name LIKE "*attacker*" OR runtime_kubernetes.pod.name LIKE "*attacker*" OR message LIKE "*attacker*"
| SORT @timestamp ASC
| KEEP @timestamp, event.source, event.type, event.action, kubernetes.namespace, kubernetes.pod.name, runtime_kubernetes.namespace, runtime_kubernetes.pod.name, process.executable, file.path, message
```
