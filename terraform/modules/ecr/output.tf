output "app-repository-URL" {
  value = aws_ecr_repository.this.repository_url
}

output "app-repository-ARN" {
  value = aws_ecr_repository.this.arn
}
