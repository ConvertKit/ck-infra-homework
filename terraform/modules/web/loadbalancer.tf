resource "aws_lb" "web_lb" {
  depends_on                        = ["aws_internet_gateway.gw"]
  name                              = "web-lb"
  internal                          = false
  load_balancer_type                = "network"
  subnets                           = ["${aws_subnet.web_subnet_a.id}", "${aws_subnet.web_subnet_b.id}", "${aws_subnet.web_subnet_c.id}"]
  enable_cross_zone_load_balancing  = true
  enable_deletion_protection        = false

  tags {
    Environment = "web_lb"
  }
}

// HTTP target group
resource "aws_lb_target_group" "web_app_http" {
  name     = "web-lb-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.web_app_vpc.id}"
}


// HTTPS target group
resource "aws_lb_target_group" "web_app_https" {
  name     = "web-lb-tg-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.web_app_vpc.id}"
  deregistration_delay = 10
}

// HTTP Listener
resource "aws_lb_listener" "web_app_http" {
  load_balancer_arn = "${aws_lb.web_lb.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_app_http.arn}"
  }
}

// HTTPS Listener
resource "aws_lb_listener" "web_app_https" {
  load_balancer_arn = "${aws_lb.web_lb.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_app_https.arn}"
  }
}
