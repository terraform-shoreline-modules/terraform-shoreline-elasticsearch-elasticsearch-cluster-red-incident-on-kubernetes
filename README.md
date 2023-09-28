
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Cluster Red Incident on Kubernetes.
---

The Elasticsearch Cluster Red incident occurs when the Elasticsearch cluster is experiencing issues and is in a critical state. This can cause interruptions to the functionality of various systems that rely on Elasticsearch. Immediate attention is required to resolve the issue and restore the Elasticsearch cluster to a healthy state.

### Parameters
```shell
export CLUSTER_NAME="PLACEHOLDER"

export ELASTICSEARCH_POD_NAME="PLACEHOLDER"

export ELASTICSEARCH_DEPLOYMENT_NAME="PLACEHOLDER"

export ELASTICSEARCH_NAMESPACE="PLACEHOLDER"

export ELASTICSEARCH_POD_IP="PLACEHOLDER"
```

## Debug

### Get the name of the Elasticsearch cluster
```shell
kubectl get elasticsearch
```

### Describe the Elasticsearch cluster to get more details
```shell
kubectl describe elasticsearch ${CLUSTER_NAME}
```

### Check the Elasticsearch cluster health
```shell
kubectl exec ${ELASTICSEARCH_POD_NAME} --namespace=${ELASTICSEARCH_NAMESPACE} -- curl -s -X GET http://localhost:9200/_cluster/health
```

### Check the Elasticsearch cluster status
```shell
kubectl exec ${ELASTICSEARCH_POD_NAME} --namespace=${ELASTICSEARCH_NAMESPACE} -- curl -s -X GET http://localhost:9200/_cat/health
```

### Check the Elasticsearch cluster logs
```shell
kubectl logs ${ELASTICSEARCH_POD_NAME} --namespace=${ELASTICSEARCH_NAMESPACE}
```

### Check the Elasticsearch cluster configuration for any errors
```shell
kubectl exec ${ELASTICSEARCH_POD_NAME} --namespace=${ELASTICSEARCH_NAMESPACE} -- cat /usr/share/elasticsearch/config/elasticsearch.yml
```

### Check the Elasticsearch cluster nodes
```shell
kubectl exec ${ELASTICSEARCH_POD_NAME} --namespace=${ELASTICSEARCH_NAMESPACE} -- curl -s -X GET http://localhost:9200/_cat/nodes?v
```

### Network issues: Elasticsearch cluster red status can also be caused by network issues. This can occur when there are network connectivity issues between the nodes in the cluster or when the network is not properly configured.
```shell
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


```

## Repair

### Restart Elasticsearch nodes: If the issue is minor and isolated to a few nodes, restarting the nodes can help resolve the issue. However, if the issue is more severe, restarting the entire cluster may be necessary.
```shell


#!/bin/bash



# Set the namespace and Elasticsearch deployment name

NAMESPACE=${ELASTICSEARCH_NAMESPACE}

DEPLOYMENT=${ELASTICSEARCH_DEPLOYMENT_NAME}



# Use rolling restart to restart pods one by one
kubectl rollout restart deployment/${DEPLOYMENT} -n ${NAMESPACE}
```