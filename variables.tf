variable "environment" {
  default     = "prod"
  type        = string
  description = "Name of the environment."
}

variable "region" {
  default     = "eu-central-1"
  type        = string
  description = "Name of the AWS region."
}

variable "resource_prefix" {
  default     = "tme"
  type        = string
  description = "Prefix for AWS resources."
}