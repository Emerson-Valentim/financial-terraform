variable "common" {
  type = object({
    environment = string
    alias       = string
  })
  default = {
    environment = "production",
    alias       = "andre"
  }
}

module "infra" {
  source = "../../setup"
  common = var.common
}