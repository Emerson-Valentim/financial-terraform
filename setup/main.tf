terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "sa-east-1"
}

module "database" {
  source = "../modules/database"

  authentication = {
    username = "postgres"
    password = "postgres"
    port     = 5432
  }

  common = var.common

  network = var.network
}

module "cloudwatch" {
  source     = "../modules/cloudwatch"
  common     = var.common
  log_groups = ["api"]
}

module "load_balancer" {
  source  = "../modules/load_balancer"
  common  = var.common
  network = var.network
}

# module "ecs" {
#   source               = "../modules/ecs"
#   common               = var.common
#   network              = var.network
#   database        = module.database.database_config
# }