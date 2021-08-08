output "lb_address" {
  value = module.infra.config.dns_name
}

output "service" {
  value = module.infra.config.service
}

output "cluster" {
  value = module.infra.config.cluster
}

output "task-definition" {
  value = module.infra.config.task-definition
}