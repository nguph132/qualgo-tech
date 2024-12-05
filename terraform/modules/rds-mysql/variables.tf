variable "database_name" {
  description = "Database name"
  type        = string
  default     = "my_database"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "qualgo_admin"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 10
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in gigabytes"
  type        = number
  default     = 50
}

variable "storage_type" {
  description = "Type of storage"
  type        = string
  default     = "gp2"
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "mysql_family" {
  description = "MySQL family version"
  type        = string
  default     = "mysql8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip taking a final snapshot before destroying the database"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "allowed_source_security_group_id" {
  description = "SG id allowed to connect to the RDS instance"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR allowed to connect to the RDS instance"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the RDS resources"
  type        = map(string)
  default = {
    Environment = "test"
    Project     = "qualgo"
    Name        = "qualgo"
  }
}

# Define a variable to store MySQL parameters as a map
variable "mysql_parameters" {
  description = "MySQL parameters to customize"
  type = map(object({
    name  = string
    value = string
  }))
  default = {}
}