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

variable "log_groups" {
    type = list(string)
    default = ["api"]
}