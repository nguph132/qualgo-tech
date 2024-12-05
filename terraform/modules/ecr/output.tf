output "qualgo_repositories" {
  description = "List of created ECR repository names."
  value       = [for repo in aws_ecr_repository.qualgo_repositories : repo.repository_url]
}