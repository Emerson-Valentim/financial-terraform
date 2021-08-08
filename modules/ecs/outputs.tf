output "config" {
  value = {
    service         = "${var.common.alias}-financial-api-${var.common.environment}"
    cluster         = "financial-${var.common.alias}"
    task-definition = "${var.common.alias}-financial-api-${var.common.environment}"
  }
}