resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  comment = "OAI to restrict access to AWS S3 content"
}

resource "aws_cloudfront_distribution" "website" {
  aliases = [
    local.website_bucket_name,
    local.www_website_bucket_name
  ]

  web_acl_id = var.cloudfront_web_acl_id

  comment = var.comment_for_cloudfront_website

  default_cache_behavior {
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-CORS-S3Origin
    allowed_methods          = var.cloudfront_allowed_cached_methods
    cached_methods           = var.cloudfront_allowed_cached_methods
    target_origin_id         = local.website_bucket_name
    viewer_protocol_policy   = var.cloudfront_viewer_protocol_policy
    compress                 = var.cloudfront_enable_compression

    dynamic "function_association" {
      for_each = var.cloudfront_function_association
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_responses
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  http_version        = var.cloudfront_http_version

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.website_bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
      locations        = var.cloudfront_geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate_validation.cert_validation.certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  retain_on_delete    = var.cloudfront_website_retain_on_delete
  wait_for_deployment = var.cloudfront_website_wait_for_deployment
}