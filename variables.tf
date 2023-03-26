variable "region" {
  default = "eu-central-1"
  type = string
}

variable "domains" {
    type = map(any)
}