bash

# Check if Elasticsearch pods are running

es_pod=$(kubectl get pods -l app=elasticsearch -o jsonpath='{.items[0].metadata.name}')

if [ -z "$es_pod" ]; then

  echo "Error: Elasticsearch pods not found"

  exit 1

fi



# Check network connectivity between Elasticsearch pods

if ! kubectl exec "$es_pod" -- curl -sS -o /dev/null -w "%{http_code}" http://${ELASTICSEARCH_POD_IP}:9200/_cat/health; then

  echo "Error: Elasticsearch network connectivity issues"

  exit 1

fi



echo "Network connectivity between Elasticsearch nodes is healthy"