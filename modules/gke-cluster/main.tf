resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network
  network    = "default"
  subnetwork = "default"

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Resource labels
  resource_labels = var.labels

  # Deletion protection (set to false for testing)
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = var.labels
    tags   = var.tags
  }
}
