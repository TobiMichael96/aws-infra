locals {
  website_bucket_name     = var.website_domain_name
  www_website_bucket_name = "www.${var.website_domain_name}"
}

resource "aws_s3_bucket" "this" {
  bucket        = local.website_bucket_name
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = var.website_cors_allowed_headers
    allowed_methods = var.website_cors_allowed_methods
    allowed_origins = concat(
      ((var.cloudfront_viewer_protocol_policy == "allow-all") ?
        ["http://${var.website_domain_name}", "https://${var.website_domain_name}"] :
      ["https://${var.website_domain_name}"]),
    var.website_cors_additional_allowed_origins)
    expose_headers  = var.website_cors_expose_headers
    max_age_seconds = var.website_cors_max_age_seconds
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  ignore_public_acls      = true
  block_public_acls       = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(
        {
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "OAIAccessOnly",
                Effect = "Allow",
                Principal = {
                    AWS = "${aws_cloudfront_origin_access_identity.cf_oai.iam_arn}"
                },
                Action = "s3:GetObject",
                Resource = "arn:aws:s3:::${local.website_bucket_name}/*"
            }
        ]
    }
  )
}

# resource "aws_s3_bucket_website_configuration" "this" {
#   bucket = aws_s3_bucket.this.id

#   index_document {
#     key = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }