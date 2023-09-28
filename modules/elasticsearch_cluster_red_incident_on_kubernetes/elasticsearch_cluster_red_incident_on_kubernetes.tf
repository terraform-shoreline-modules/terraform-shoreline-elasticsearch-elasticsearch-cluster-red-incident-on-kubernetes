resource "shoreline_notebook" "elasticsearch_cluster_red_incident_on_kubernetes" {
  name       = "elasticsearch_cluster_red_incident_on_kubernetes"
  data       = file("${path.module}/data/elasticsearch_cluster_red_incident_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_check_es_network_connectivity,shoreline_action.invoke_restart_elasticsearch_deploy]
}

resource "shoreline_file" "check_es_network_connectivity" {
  name             = "check_es_network_connectivity"
  input_file       = "${path.module}/data/check_es_network_connectivity.sh"
  md5              = filemd5("${path.module}/data/check_es_network_connectivity.sh")
  description      = "Network issues: Elasticsearch cluster red status can also be caused by network issues. This can occur when there are network connectivity issues between the nodes in the cluster or when the network is not properly configured."
  destination_path = "/agent/scripts/check_es_network_connectivity.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_elasticsearch_deploy" {
  name             = "restart_elasticsearch_deploy"
  input_file       = "${path.module}/data/restart_elasticsearch_deploy.sh"
  md5              = filemd5("${path.module}/data/restart_elasticsearch_deploy.sh")
  description      = "Restart Elasticsearch nodes: If the issue is minor and isolated to a few nodes, restarting the nodes can help resolve the issue. However, if the issue is more severe, restarting the entire cluster may be necessary."
  destination_path = "/agent/scripts/restart_elasticsearch_deploy.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_es_network_connectivity" {
  name        = "invoke_check_es_network_connectivity"
  description = "Network issues: Elasticsearch cluster red status can also be caused by network issues. This can occur when there are network connectivity issues between the nodes in the cluster or when the network is not properly configured."
  command     = "`chmod +x /agent/scripts/check_es_network_connectivity.sh && /agent/scripts/check_es_network_connectivity.sh`"
  params      = ["ELASTICSEARCH_POD_IP"]
  file_deps   = ["check_es_network_connectivity"]
  enabled     = true
  depends_on  = [shoreline_file.check_es_network_connectivity]
}

resource "shoreline_action" "invoke_restart_elasticsearch_deploy" {
  name        = "invoke_restart_elasticsearch_deploy"
  description = "Restart Elasticsearch nodes: If the issue is minor and isolated to a few nodes, restarting the nodes can help resolve the issue. However, if the issue is more severe, restarting the entire cluster may be necessary."
  command     = "`chmod +x /agent/scripts/restart_elasticsearch_deploy.sh && /agent/scripts/restart_elasticsearch_deploy.sh`"
  params      = ["ELASTICSEARCH_DEPLOYMENT_NAME","ELASTICSEARCH_NAMESPACE","NAMESPACE"]
  file_deps   = ["restart_elasticsearch_deploy"]
  enabled     = true
  depends_on  = [shoreline_file.restart_elasticsearch_deploy]
}

