$ErrorActionPreference = "Stop"

kubectl apply -k elastic-pipeline

kubectl -n observability rollout status deployment/logstash --timeout=300s
kubectl -n observability rollout status ds/filebeat --timeout=300s

kubectl -n observability get pods -o wide
