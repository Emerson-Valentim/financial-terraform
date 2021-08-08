output "lb_address" {
  value = module.load_balancer.config.dns_name
}