output "elb" {
  value = aws_elb.this-elb.dns_name
}

output "service-name" {
  value = aws_ecs_service.this-service
}

output "cluster-id" {
  value = aws_ecs_cluster.id
}
