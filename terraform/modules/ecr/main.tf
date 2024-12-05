# Create ECR Repository
resource "aws_ecr_repository" "qualgo_repositories" {
  for_each = toset(var.qualgo_repositories)
  name     = each.value
  lifecycle {
    prevent_destroy = true
  }
  tags = var.repository_tags
}