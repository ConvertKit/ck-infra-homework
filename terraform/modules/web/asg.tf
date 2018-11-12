// launch configuration
resource "aws_launch_configuration" "web-app-lc" {
  name_prefix          = "web-app-"
  image_id             = "${var.ec2_ami}"
  instance_type        = "${var.amisize}"
  user_data            = "${data.template_file.web-init.rendered}"

  security_groups = [
    "${aws_security_group.web-app-sg.id}",
    "${aws_security_group.efs-sg.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  key_name = "${var.key_name}"
}

//  Auto-scaling group for our cluster.
resource "aws_autoscaling_group" "web-app-asg" {
  depends_on           = ["aws_launch_configuration.web-app-lc"]
  name                 = "${var.asgname}"
  launch_configuration = "${aws_launch_configuration.web-app-lc.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${aws_subnet.web_subnet_a.id}", "${aws_subnet.web_subnet_b.id}", "${aws_subnet.web_subnet_c.id}"]
  target_group_arns    = ["${aws_lb_target_group.web_app_http.arn}", "${aws_lb_target_group.web_app_https.arn}"]
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]
  health_check_grace_period = 10

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Web Node - ${var.docker_image}:${var.docker_tag}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "web-app"
    propagate_at_launch = true
  }
}
