
resource "aws_ecs_cluster" "cluster" {
  name = "financial-${var.common.alias}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  tags = {
    Service = "${var.common.alias}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${var.common.alias}-financial-api-${var.common.environment}"

  task_role_arn      = "arn:aws:iam::488735367158:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::488735367158:role/ecsTaskExecutionRole"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  memory = 512
  cpu    = 256

  container_definitions = jsonencode(
    [
      {
        "cpu" : 0,
        "environment" : [
          {
            "name" : "APP_KEY",
            "value" : "iq90dswa90fi091i20fdisa9ujf9p1jfdp"
          },
          {
            "name" : "DB_CONNECTION",
            "value" : "pg"
          },
          {
            "name" : "DB_HOST",
            "value" : "${var.database.host}"
          },
          {
            "name" : "DB_NAME",
            "value" : "financial_${var.common.alias}"
          },
          {
            "name" : "DB_PASSWORD",
            "value" : "${var.database.password}"
          },
          {
            "name" : "DB_PORT",
            "value" : "${tostring(var.database.port)}"
          },
          {
            "name" : "DB_USER",
            "value" : "${var.database.username}"
          },
          {
            "name" : "HEADER_API_KEY",
            "value" : "aXRhw7o="
          },
          {
            "name" : "HOST",
            "value" : "0.0.0.0"
          },
          {
            "name" : "NODE_ENV",
            "value" : "${var.common.environment}"
          },
          {
            "name" : "PORT",
            "value" : "3333"
          },
          {
            "name" : "TZ",
            "value" : "America/Sao_Paulo"
          }
        ],
        "essential" : true,
        "image" : "488735367158.dkr.ecr.sa-east-1.amazonaws.com/financial-api:dev_latest",
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "/ecs/financial-api/${var.common.alias}/api",
            "awslogs-region" : "sa-east-1",
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "mountPoints" : [],
        "name" : "financial-api",
        "portMappings" : [
          {
            "containerPort" : 3333,
            "hostPort" : 3333,
            "protocol" : "tcp"
          }
        ],
        "volumesFrom" : []
      },
      {
        "cpu" : 0,
        "environment" : [
          {
            "name" : "APP_KEY",
            "value" : "iq90dswa90fi091i20fdisa9ujf9p1jfdp"
          },
          {
            "name" : "DB_CONNECTION",
            "value" : "pg"
          },
          {
            "name" : "DB_HOST",
            "value" : "${var.database.host}"
          },
          {
            "name" : "DB_NAME",
            "value" : "financial_${var.common.alias}"
          },
          {
            "name" : "DB_PASSWORD",
            "value" : "${var.database.password}"
          },
          {
            "name" : "DB_PORT",
            "value" : "${tostring(var.database.port)}"
          },
          {
            "name" : "DB_USER",
            "value" : "${var.database.username}"
          },
          {
            "name" : "HEADER_API_KEY",
            "value" : "aXRhw7o="
          },
          {
            "name" : "HOST",
            "value" : "0.0.0.0"
          },
          {
            "name" : "NODE_ENV",
            "value" : "${var.common.environment}"
          },
          {
            "name" : "PORT",
            "value" : "3333"
          },
          {
            "name" : "TZ",
            "value" : "America/Sao_Paulo"
          }
        ],
        "essential" : false,
        "image" : "488735367158.dkr.ecr.sa-east-1.amazonaws.com/financial-api:dev_latest",
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "/ecs/financial-api/${var.common.alias}/migration",
            "awslogs-region" : "sa-east-1",
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "mountPoints" : [],
        "workingDirectory" : "/home/node/app",
        "name" : "financial-api-migration",
        "entryPoint" : [
          "yarn",
          "migrate"
        ],
        "portMappings" : [],
        "command" : [
          "yarn",
          "migrate"
        ],
        "volumesFrom" : []
      }
    ]
  )

  tags = {
    Environment = "${var.common.environment}"
    Service     = "${var.common.alias}"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.common.alias}-financial-api-${var.common.environment}"

  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn

  load_balancer {
    target_group_arn = var.load_balancer.target_group
    container_name   = "financial-api"
    container_port   = 3333
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  health_check_grace_period_seconds = 0
  desired_count                     = 1
  platform_version                  = "LATEST"
  enable_ecs_managed_tags           = true
  enable_execute_command            = false

  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = var.network.security_groups.ecs
    subnets          = var.network.subnets
  }

  tags = {
    Environment = "${var.common.environment}"
    Service     = "${var.common.alias}"
  }

}