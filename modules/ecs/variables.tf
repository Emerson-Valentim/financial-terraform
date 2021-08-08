variable "common" {
  type = object({
    environment = string
    alias       = string
  })
  default = {
    environment = "staging",
    alias       = "None"
  }
}

variable "network" {
  description = "Network variables"
  type = object({
    vpc     = string
    subnets = list(string)
    security_groups = object({
      load_balancer = list(string)
      ecs           = list(string)
      database      = list(string)
  }) })
  default = {
    security_groups = {
      load_balancer = [""]
      ecs           = [""]
      database      = [""]
    }
    subnets = [""]
    vpc     = ""
  }
}

variable "database" {
  description = "Default database configs"
  type = object({
    host = string
    username      = string
    password      = string
    port          = number
  })
  default = {
    host = ""
    username      = ""
    password      = ""
    port          = 0
  }
}

variable "load_balancer" {
  description = "Load balancer config"
  type = object({
    dns_name     = string
    zone_id      = string
    target_group = string
  })
  default = {
    dns_name     = ""
    zone_id      = ""
    target_group = ""
  }
}