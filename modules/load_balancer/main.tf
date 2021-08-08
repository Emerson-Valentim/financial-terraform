resource "aws_lb" "load_balancer" {
  name               = "ecs-${var.common.alias}-financial-api"
  load_balancer_type = "application"

  subnets         = var.network.subnets
  security_groups = var.network.security_groups.load_balancer

  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true

  ip_address_type = "ipv4"

  tags = {
    Environment = "${var.common.environment}"
    Service     = "${var.common.alias}"
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name = "${var.common.alias}-${substr(var.common.environment, 0, 3)}-api-group"

  target_type = "ip"

  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.network.vpc

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/healthCheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

}

resource "aws_lb_listener" "ld_listener_http" {
  port     = 80
  protocol = "HTTP"

  load_balancer_arn = aws_lb.load_balancer.id

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.id
    type             = "forward"
  }

  tags = {
    Environment = "${var.common.environment}"
    Service     = "${var.common.alias}"
  }
}
