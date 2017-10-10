variable "launch_config_key_name" {
  default = "ck-homework"
}

data "aws_vpc" "homework" {
  id = "vpc-a69da4cf"
}

data "aws_ami" "homework_app" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ruby-2.4-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_instance_profile" "s3_read_only" {
  name = "s3-read-only"
}

data "aws_security_group" "app" {
  name = "rails-app-dmz"
}

data "aws_subnet_ids" "dmz" {
  vpc_id = "${data.aws_vpc.homework.id}"
  tags {
    Segment = "dmz"
  }
}

resource "aws_launch_configuration" "main" {
  image_id                    = "${data.aws_ami.homework_app.id}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile        = "${data.aws_iam_instance_profile.s3_read_only.name}"
  key_name                    = "${var.launch_config_key_name}"
  security_groups             = ["${data.aws_security_group.app.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.main.name}"
  max_size             = 3
  min_size             = 2
  vpc_zone_identifier  = ["${data.aws_subnet_ids.dmz.ids}"]

  lifecycle {
    create_before_destroy = true
  }
}
