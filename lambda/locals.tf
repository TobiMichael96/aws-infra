locals {
  lambda_function_name = var.prefix_lambda_function == "" ? var.lambda_function_name : "${var.prefix_lambda_function}-${var.lambda_function_name}"

  lambda_input_path = var.lambda_input_path == "" ? "${path.module}/src/" : var.lambda_input_path
  lambda_output_path = var.lambda_output_path == "" ? "${path.module}/function.zip" : var.lambda_output_path

  sid = "${replace(local.lambda_function_name, "-", "")}${var.environment}"
}