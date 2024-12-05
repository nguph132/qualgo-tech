variable "sg_list" {
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "sg_qualgo_backend_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    cidr_blocks = list(string)
  }))
}