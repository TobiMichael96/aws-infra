output "name_servers" {
    value = { for domain in keys(var.domains) : domain => aws_route53_zone.this[domain].name_servers }
}

output "zone_ids" {
    value = { for domain in keys(var.domains) : domain => aws_route53_zone.this[domain].zone_id }
}

output "dkim_tokens" {
  value = { for idx, element in aws_ses_domain_dkim.ses_domain_dkim : idx => element.dkim_tokens }
}