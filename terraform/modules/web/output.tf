output "web_vpc_id" {
  value = "${aws_vpc.web_app_vpc.id}"
}

output "web_nlb_address" {
  value = "${aws_lb.web_lb.dns_name}"
}
