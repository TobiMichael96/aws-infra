
# module "imap_cleanup_secret" {
#   source      = "./secrets"
#   secret_name = "imap-cleanup"
#   environment = var.environment
#   prefix_secret = var.resource_prefix
# }

# module "imap_cleanup" {
#   source                 = "./lambda"
#   lambda_function_name   = "imap-cleanup"
#   prefix_lambda_function = var.resource_prefix
#   region                 = var.region
#   environment            = var.environment
#   config_secret_arn      = [module.imap_cleanup_secret.secret_arn]
#   lambda_env_variables   = {
#     region    = var.region,
#     secret_id = module.imap_cleanup_secret.secret_id
#   }
# }

module "tobiasmichael_zone" {
  source = "./route53"
  domain = "tobiasmichael.de"
  additional_records = [
    {
      name    = "tobiasmichael.de"
      type    = "MX"
      ttl     = "150"
      records = ["5 smtpin.rzone.de"]
    },
  ]
}

module "tobiasmichael_website" {
  source                 = "./website"
  route53_hosted_zone_id = module.tobiasmichael_zone.zone_id
  website_domain_name    = "tobiasmichael.de"

  cloudfront_custom_error_responses = [
    {
      error_caching_min_ttl = 30,
      error_code            = 403,
      response_code         = 200,
      response_page_path    = "error.html"
    },
    {
      error_caching_min_ttl = 30,
      error_code            = 404,
      response_code         = 200,
      response_page_path    = "error.html"
    }
  ]

  providers = {
    aws             = aws,
    aws.certificate = aws.certificate
  }
}