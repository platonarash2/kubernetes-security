# Operational notes

## Filebeat

Filebeat is responsible only for collecting node container logs.

## Logstash

Logstash is responsible for parsing and normalization. This is where raw JSON from Tetragon/KubeArmor is converted into queryable fields.

## Elasticsearch

Elasticsearch receives already-normalized documents in:

```text
runtime-security-YYYY.MM.dd
```

## Production note

For AKS production, prefer Elastic Agent or Filebeat as the node-level collector and keep parsing/normalization in Logstash or Elastic ingest pipelines.
