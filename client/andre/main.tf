variable "common" {
    type = object({
        environment = string
        alias = string
    })
    default = {
        environment = "production",
        alias = "Andre"
    }
}

module "infra" {
  source = "../../setup"
  common = var.common
}