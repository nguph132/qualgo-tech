variable "qualgo_repositories" {
  description = "List of repositories"
  type        = list(string)
  default     = []
}

variable "repository_tags" {
  description = "Tags to associate with the repository"
  type        = map(string)
  default = {
    "Project" = "qualgo"
  }
}