variable "region" {
  type = string
  description = "AWS region."
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function."
}

variable "prefix_lambda_function" {
  default     = ""
  type        = string
  description = "Prefix of the lambda function."
}

variable "environment" {
  type        = string
  description = "Name of the environment."
}

variable "lambda_input_path" {
  default     = ""
  type        = string
  description = "Lambda input path."
}

variable "lambda_output_path" {
  default     = ""
  type        = string
  description = "Lambda output path."
}

variable "lambda_runtime" {
  default     = "nodejs18.x"
  type        = string
  description = "Lambda runtime."
}

variable "lambda_handler" {
  default     = "index.handler"
  type        = string
  description = "Lambda handler."
}

variable "lambda_timeout" {
  default     = 5
  type        = number
  description = "Lambda timeout."
}

variable "kms_arn" {
  default = []
  type = list(string)
  description = "ARN of the KMS keys."
}

variable "dynamodb_arn" {
  default = []
  type = list(string)
  description = "ARN of the dynamo db."
}

variable "dead_letter_arn" {
  default = []
  type = list(string)
  description = "ARN of the dead letter sqs queue."
}

variable "config_secret_arn" {
  default = []
  type = list(string)
  description = "Arn of the secret for the credentials/configuration."
}

variable "lambda_env_variables" {
  type = map(any)
  default = {}
  description = "Map of environment variables for the lambda function."
}