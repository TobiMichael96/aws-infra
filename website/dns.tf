resource "aws_route53_record" "website_cloudfront_record" {
  zone_id = var.route53_hosted_zone_id
  name    = local.website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_website_record" {
  zone_id = var.route53_hosted_zone_id
  name    = local.www_website_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}