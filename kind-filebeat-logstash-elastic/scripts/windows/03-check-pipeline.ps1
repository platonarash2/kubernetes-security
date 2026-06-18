$ErrorActionPreference = "Continue"

Write-Host "Logstash logs:"
kubectl -n observability logs deploy/logstash --tail=80

Write-Host "Filebeat logs:"
kubectl -n observability logs ds/filebeat --tail=80

Write-Host "Elasticsearch indices:"
$pwd = kubectl -n elastic-system get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
kubectl -n elastic-system port-forward svc/quickstart-es-http 9200:9200
