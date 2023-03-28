variable "domain" {
  type = string
}

variable "additional_records" {
    type = list(object({
        name = string
        type = string
        records = list(string)
        ttl = number
    }))

    default = []
}