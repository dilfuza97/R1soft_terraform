resource "aws_route53_record" "r1soft"  {
  zone_id = "${var.zone_id}"
  name    = "r1soft.${var.domain}"   
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.r1soft.public_ip}"]
}
