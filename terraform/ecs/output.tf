# output "elb" {
#   value = module.ecs.dns_name
# }

output service_name {
    value =module.ecs.service-name
}

output cluster_id {
    value= module.ecs.cluster-id
}