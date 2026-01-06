# Existing variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "node_count" {
  description = "Number of nodes (used when autoscaling is disabled)"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 30
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "pd-standard"
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

variable "service_account" {
  description = "Service account email"
  type        = string
  default     = null
}

# ===========================
# AUTOSCALING VARIABLES
# ===========================

variable "enable_autoscaling" {
  description = "Enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes in the pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the pool"
  type        = number
  default     = 5
}

variable "location_policy" {
  description = "Location policy for autoscaling (BALANCED or ANY)"
  type        = string
  default     = "BALANCED"
}

# ===========================
# CLUSTER AUTOSCALING (NAP)
# ===========================

variable "enable_cluster_autoscaling" {
  description = "Enable cluster autoscaling (Node Auto-Provisioning)"
  type        = bool
  default     = false
}

variable "autoscaling_cpu_min" {
  description = "Minimum CPU cores for auto-provisioning"
  type        = number
  default     = 1
}

variable "autoscaling_cpu_max" {
  description = "Maximum CPU cores for auto-provisioning"
  type        = number
  default     = 20
}

variable "autoscaling_memory_min" {
  description = "Minimum memory (GB) for auto-provisioning"
  type        = number
  default     = 1
}

variable "autoscaling_memory_max" {
  description = "Maximum memory (GB) for auto-provisioning"
  type        = number
  default     = 64
}

# ===========================
# COST OPTIMIZATION
# ===========================

variable "use_spot_vms" {
  description = "Use Spot VMs for cost savings (can be preempted)"
  type        = bool
  default     = false
}


# ===========================
# NETWORKING
# ===========================

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "default"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "default"
}