
module "imap_cleanup_secret" {
  source      = "./secrets"
  secret_name = "imap-cleanup"
  environment = var.environment
}

module "imap_cleanup" {
  source                 = "./lambda"
  lambda_function_name   = "imap-cleanup"
  prefix_lambda_function = var.resource_prefix
  region                 = var.region
  environment            = var.environment
  config_secret_arn      = module.imap_cleanup_secret.secret_arn
  lambda_env_variables   = {
    region    = var.region,
    secret_id = module.imap_cleanup_secret.secret_id
  }
}