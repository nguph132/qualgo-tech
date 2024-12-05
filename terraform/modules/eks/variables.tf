variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet CIDR blocks"
  type        = list(string)
  default     = [""]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.27"
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    "Environment" = "production"
    "Project"     = "eks-cluster"
  }
}

variable "eks_managed_node_groups" {
  description = "Map of EKS Node Groups"
  type = map(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
    ami_type       = string
    disk_size      = number
    tags           = map(string)
  }))
  default = {}
}

variable "admin_users" {
  description = "A map of admin users and their configurations"
  type        = map(object({}))
  default     = {}
}