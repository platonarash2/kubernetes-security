$ErrorActionPreference = "Continue"

$paymentsPod = kubectl -n payments get pod -l app=payments-api -o jsonpath='{.items[0].metadata.name}'
$attackerPod = kubectl -n attacker get pod -l app=attacker -o jsonpath='{.items[0].metadata.name}'
$clientPod = kubectl -n payments get pod -l app=payments-client -o jsonpath='{.items[0].metadata.name}'

Write-Host "Test 1: payments-api service account token should not exist"
kubectl -n payments exec $paymentsPod -- sh -c 'ls -l /var/run/secrets/kubernetes.io/serviceaccount/token || true'

Write-Host "Test 2: attacker pod reads service account token"
kubectl -n attacker exec $attackerPod -- sh -c 'ls -l /var/run/secrets/kubernetes.io/serviceaccount/token && head -c 20 /var/run/secrets/kubernetes.io/serviceaccount/token || true'

Write-Host "Test 3: shell execution in payments-api"
kubectl -n payments exec $paymentsPod -- sh -c '/bin/sh -c "echo shell-test"' 

Write-Host "Test 4: Cilium policy: payments-client should reach payments-api"
kubectl -n payments exec $clientPod -- curl -sS --max-time 5 http://payments-api:8080

Write-Host "Test 5: Cilium pods"
kubectl -n kube-system get pods -l k8s-app=cilium -o wide

Write-Host "Test 6: Tetragon logs"
kubectl -n tetragon logs -l app.kubernetes.io/name=tetragon --tail=100

Write-Host "Test 7: KubeArmor logs"
kubectl -n kubearmor logs -l kubearmor-app=kubearmor --tail=100
