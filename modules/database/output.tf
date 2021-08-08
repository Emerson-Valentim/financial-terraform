output "config" {
  value = {
    database_host = aws_db_instance.rds_db.address
    username      = var.authentication.username
    password      = var.authentication.password
  }
}