variable "common" {
    type = object({
        environment = string
        alias = string
    })
    default = {
        environment = "staging",
        alias = "none"
    }
}

variable "authentication" {
    type = object({
        username = string
        password = string
        port = number
    })
}