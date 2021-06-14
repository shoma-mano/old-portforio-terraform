resource "aws_route53_record" "cloudfront"{
  name    = "yourDomainName"
  type    = "A"
  zone_id = "yourZoneId"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
  }

}
