resource "aws_cloudfront_distribution" "main"{
  aliases                        = [
    "top.myhero12.work",
  ]
  default_root_object            = "index.html"
  enabled                        = true
  http_version                   = "http2"
  is_ipv6_enabled                = true
  price_class                    = "PriceClass_100"
  retain_on_delete               = false
  tags                           = {}
  tags_all                       = {}

  wait_for_deployment            = true

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods        = [
      "GET",
      "HEAD",
    ]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "S3-myhero12.work"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = "myhero12.work.s3-ap-northeast-1.amazonaws.com"
    origin_id   = "S3-myhero12.work"
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = ""
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }

}
