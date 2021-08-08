variable "common" {
    type = object({
        environment = string
        alias = string
    })
    default = {
        environment = "staging",
        alias = "None"
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