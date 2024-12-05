output "qualgo_repositories" {
  value = module.ecr.qualgo_repositories
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "users_access_keys" {
  value     = module.iam.users_access_keys
  sensitive = true
}

output "mysql_info" {
  value     = module.mysql.mysql_info
  sensitive = true
}

output "api_gateway_endpoint" {
  value = module.api_gateway.api_gateway_endpoint
}