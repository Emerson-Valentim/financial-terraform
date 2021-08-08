resource "aws_cloudwatch_log_group" "default_log_group" {
  for_each = { for log_group_key, log_group in var.log_groups : log_group_key => log_group }

  name = "/ecs/financial-api/${var.common.alias}/${each.value}"

  tags = {
    Environment = "${var.common.environment}"
    Service     = "${var.common.alias}"
  }
}