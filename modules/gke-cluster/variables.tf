variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-small"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 30
}

variable "labels" {
  description = "Labels to apply"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Network tags"
  type        = list(string)
  default     = []
}
