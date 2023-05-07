module "ecs" {
    source ="../modules/ecs"
    name = var.name
    region = var.region
    key_name= var.key_name
    instance_type = var.instance_type
    repo_url = var.repo_url
}