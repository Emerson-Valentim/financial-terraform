output "config" {
  dns_name     = aws_lb.load_balancer.dns_name
  zone_id      = aws_lb.load_balancer.zone_id
  target_group = aws_lb_target_group.lb_target_group.arn
  description  = "Load balancer configs"
}
