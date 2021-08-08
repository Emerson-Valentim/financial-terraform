resource "aws_db_instance" "rds_db" {
  identifier = "${var.common.alias}-database"

  engine                     = "postgres"
  engine_version             = "12.5"
  allocated_storage          = 20
  auto_minor_version_upgrade = true
  instance_class             = "db.t2.micro"

  username = var.authentication.username
  password = var.authentication.password

  availability_zone   = "sa-east-1b"
  publicly_accessible = true

  vpc_security_group_ids = var.network.security_groups.database
  db_subnet_group_name   = "default-${var.network.vpc}"

  parameter_group_name = "default.postgres12"

  skip_final_snapshot = true
  tags = {
    Service = "${var.common.alias}"
  }
}

terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.13.0"
    }
  }
}

provider "postgresql" {
  alias = "pg-default"

  host = aws_db_instance.rds_db.address

  username = var.authentication.username
  password = var.authentication.password
  port     = var.authentication.port

  sslmode = "disable"
}

resource "postgresql_database" "postgres_database" {
  provider = postgresql.pg-default
  name     = "financial_${var.common.alias}_${var.common.environment}"
  owner    = var.authentication.username
}