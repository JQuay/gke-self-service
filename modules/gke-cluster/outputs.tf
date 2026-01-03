output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_zone" {
  description = "Cluster zone"
  value       = google_container_cluster.primary.location
}

output "get_credentials_command" {
  description = "Command to get cluster credentials"
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}"
}
