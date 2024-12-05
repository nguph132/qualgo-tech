output "users_arns" {
  description = "Map of user ARNs"
  value = {
    for username, user in aws_iam_user.users :
    username => user.arn
  }
}

output "users_names" {
  description = "List of user names"
  value       = keys(aws_iam_user.users)
}

output "users_access_keys" {
  description = "Access keys for users"
  value = {
    for username, key in aws_iam_access_key.users_keys :
    username => {
      access_key_id     = key.id
      secret_access_key = key.secret
    }
  }
  sensitive = true
}