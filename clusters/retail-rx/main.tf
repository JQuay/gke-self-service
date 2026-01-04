terraform {
  required_version = ">= 1.0"
  
  backend "gcs" {
    bucket = "fabled-citadel-482020-i0-tf-state"
    prefix = "clusters/retail-rx"
  }
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

locals {
  config = yamldecode(file("${path.module}/cluster.yaml"))
}

module "gke_cluster" {
  source = "../../modules/gke-cluster"
  
  # Basic
  project_id   = var.project_id
  cluster_name = local.config.cluster.name
  zone         = local.config.infrastructure.zone
  
  # Node Config
  machine_type = local.config.infrastructure.machine_type
  disk_size    = local.config.infrastructure.disk_size
  
  # Autoscaling
  enable_autoscaling = local.config.autoscaling.enabled
  node_count         = local.config.autoscaling.node_count
  min_node_count     = local.config.autoscaling.min_nodes
  max_node_count     = local.config.autoscaling.max_nodes
  
  # Cost Optimization
  use_spot_vms = local.config.cost_optimization.use_spot_vms
  
  # Labels & Tags
  labels = local.config.labels
  tags   = local.config.tags
}

output "cluster_name" {
  value = module.gke_cluster.cluster_name
}

output "cluster_zone" {
  value = module.gke_cluster.cluster_zone
}

output "get_credentials_command" {
  value = module.gke_cluster.get_credentials_command
}

output "autoscaling_enabled" {
  value = module.gke_cluster.autoscaling_enabled
}
