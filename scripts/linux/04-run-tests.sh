#!/usr/bin/env bash
set -euo pipefail

PAYMENTS_POD="$(kubectl -n payments get pod -l app=payments-api -o jsonpath='{.items[0].metadata.name}')"
ATTACKER_POD="$(kubectl -n attacker get pod -l app=attacker -o jsonpath='{.items[0].metadata.name}')"
CLIENT_POD="$(kubectl -n payments get pod -l app=payments-client -o jsonpath='{.items[0].metadata.name}')"

echo "Test 1: payments-api service account token should not exist"
kubectl -n payments exec "$PAYMENTS_POD" -- sh -c 'ls -l /var/run/secrets/kubernetes.io/serviceaccount/token || true'

echo "Test 2: attacker pod reads service account token"
kubectl -n attacker exec "$ATTACKER_POD" -- sh -c 'ls -l /var/run/secrets/kubernetes.io/serviceaccount/token && head -c 20 /var/run/secrets/kubernetes.io/serviceaccount/token || true'

echo "Test 3: shell execution in payments-api"
kubectl -n payments exec "$PAYMENTS_POD" -- sh -c '/bin/sh -c "echo shell-test"' || true

echo "Test 4: Cilium policy: payments-client should reach payments-api"
kubectl -n payments exec "$CLIENT_POD" -- curl -sS --max-time 5 http://payments-api:8080 || true

echo "Test 5: Cilium connectivity status"
kubectl -n kube-system get pods -l k8s-app=cilium -o wide

echo "Test 6: Tetragon logs"
kubectl -n tetragon logs -l app.kubernetes.io/name=tetragon --tail=100 || true

echo "Test 7: KubeArmor logs"
kubectl -n kubearmor logs -l kubearmor-app=kubearmor --tail=100 || true
