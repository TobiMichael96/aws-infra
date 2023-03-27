variable "secret_name" {
  type        = string
  description = "Name of the Secret."
}

variable "prefix_secret" {
  default     = ""
  type        = string
  description = "Prefix of the Secret."
}

variable "environment" {
  type        = string
  description = "Name of the environment."
}