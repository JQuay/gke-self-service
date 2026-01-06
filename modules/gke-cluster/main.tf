resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network Configuration
  network    = var.vpc_name
  subnetwork = var.subnet_name

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Resource labels
  resource_labels = var.labels

  # Deletion protection
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  # Node count (use null if autoscaling enabled)
  node_count = var.enable_autoscaling ? null : var.node_count

  # Autoscaling
  dynamic "autoscaling" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  # Node management
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = var.labels
    tags   = var.tags

    # Spot VMs
    spot = var.use_spot_vms
  }

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}


# resource "google_container_cluster" "primary" {
#   name     = var.cluster_name
#   location = var.zone

#   # Remove default node pool
#   remove_default_node_pool = true
#   initial_node_count       = 1

#   # Network
#   network    = "default"
#   subnetwork = "default"

#   # Workload Identity
#   workload_identity_config {
#     workload_pool = "${var.project_id}.svc.id.goog"
#   }

#   # Cluster Autoscaling (Node Auto-Provisioning)
#   dynamic "cluster_autoscaling" {
#     for_each = var.enable_cluster_autoscaling ? [1] : []
#     content {
#       enabled = true

#       resource_limits {
#         resource_type = "cpu"
#         minimum       = var.autoscaling_cpu_min
#         maximum       = var.autoscaling_cpu_max
#       }

#       resource_limits {
#         resource_type = "memory"
#         minimum       = var.autoscaling_memory_min
#         maximum       = var.autoscaling_memory_max
#       }

#       auto_provisioning_defaults {
#         oauth_scopes = [
#           "https://www.googleapis.com/auth/cloud-platform"
#         ]
#         service_account = var.service_account
#       }
#     }
#   }

#   # Resource labels
#   resource_labels = var.labels

#   # Deletion protection (set to false for testing)
#   deletion_protection = false
# }

# resource "google_container_node_pool" "primary_nodes" {
#   name     = "${var.cluster_name}-node-pool"
#   location = var.zone
#   cluster  = google_container_cluster.primary.name

#   # Use node_count only if autoscaling is disabled
#   node_count = var.enable_autoscaling ? null : var.node_count

#   # Node Pool Autoscaling
#   dynamic "autoscaling" {
#     for_each = var.enable_autoscaling ? [1] : []
#     content {
#       min_node_count  = var.min_node_count
#       max_node_count  = var.max_node_count
#       location_policy = var.location_policy
#     }
#   }

#   # Node management
#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }

#   node_config {
#     machine_type = var.machine_type
#     disk_size_gb = var.disk_size
#     disk_type    = var.disk_type

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]

#     labels = var.labels
#     tags   = var.tags

#     # Spot VMs (cost savings)
#     spot = var.use_spot_vms
#   }

#   # Lifecycle
#   lifecycle {
#     ignore_changes = [
#       node_count,  # Ignore changes made by autoscaler
#     ]
#   }
# }