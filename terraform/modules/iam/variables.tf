variable "users" {
  description = "Map of usernames and permissions"
  type = map(list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  })))
}