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