

#!/bin/bash



# Set the namespace and Elasticsearch deployment name

NAMESPACE=${ELASTICSEARCH_NAMESPACE}

DEPLOYMENT=${ELASTICSEARCH_DEPLOYMENT_NAME}



# Use rolling restart to restart pods one by one
kubectl rollout restart deployment/${DEPLOYMENT} -n ${NAMESPACE}