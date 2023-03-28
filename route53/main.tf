resource "aws_route53_zone" "this" {
  name = var.domain
}

resource "aws_route53_record" "this" {
    for_each = {
        for key, value in var.additional_records : key => value
    }

    zone_id = aws_route53_zone.this.zone_id
    name    = each.value.name
    type    = each.value.type
    ttl     = each.value.ttl
    records = each.value.records
}