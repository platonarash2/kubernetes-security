$ErrorActionPreference = "Continue"

kubectl delete -k fluent-bit
kubectl delete -f elastic/elastic-stack.yaml
helm uninstall elastic-operator -n elastic-system
kubectl delete ns observability elastic-system
