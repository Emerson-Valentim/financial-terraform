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
      load_balancer = ["subnet-0c7229dea2fed41e3"]
      ecs           = ["subnet-0c7229dea2fed41e3"]
      database      = ["subnet-0c7229dea2fed41e3"]
    }
    subnets = ["subnet-0c7229dea2fed41e3", "subnet-0a577f7f95c156171", "subnet-0ddb7f6b908336c2a"]
    vpc     = "vpc-03cbe365d724107ef"
  }
}
