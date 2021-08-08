output "config" {
  value = {
    lb_address = module.load_balancer.config.dns_name
    service = module.ecs.config.service
    cluster = module.ecs.config.cluster
    task-definition = module.ecs.config.task-definition
  }
}
