output "config" {
  value = {
    host = aws_db_instance.rds_db.address
    username      = var.authentication.username
    password      = var.authentication.password
    port          = var.authentication.port
  }
}