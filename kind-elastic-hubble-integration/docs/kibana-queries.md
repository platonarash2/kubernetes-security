# Kibana queries

Create data views:

```text
runtime-security-*
hubble-flows
```

Useful searches:

```text
kubernetes.namespace_name : "kubearmor"
```

```text
kubernetes.namespace_name : "tetragon"
```

```text
kubernetes.namespace_name : "kube-system" and kubernetes.container_name : "cilium-agent"
```

```text
_index : "hubble-flows"
```

Generate events:

```powershell
kubectl -n attacker exec deploy/attacker -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl -n payments exec deploy/payments-client -- sh -c 'echo shell-test'
kubectl -n payments exec deploy/payments-client -- curl http://payments-api:8080
```
