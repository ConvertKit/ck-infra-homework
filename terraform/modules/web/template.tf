data "template_file" "web-init" {
  template = "${file("${path.module}/files/init.sh")}"

  vars {
    port = "${var.docker_port}"
    image = "${var.docker_image}"
    tag = "${var.docker_tag}"
    efs_id = "${aws_efs_file_system.web_efs.id}"
    caddyfile = "${data.template_file.caddyfile.rendered}"
    db_host = "${var.db_endpoint}"
    db_name = "${var.db_name}"
    db_username     = "${var.db_username}"
    db_password     = "${var.db_password}"
    rake_secret = "${var.rake_secret}"
    aws_config = "${data.template_file.aws_config.rendered}"
    aws_credentials = "${data.template_file.aws_credentials.rendered}"
  }
}

data "template_file" "caddyfile" {
  template = "${file("${path.module}/files/Caddyfile")}"

  vars {
    port = "${var.docker_port}"
  }
}

data "template_file" "aws_credentials" {
  template = "${file("${path.module}/files/aws_credentials")}"

  vars {
    aws_access_key = "${var.access_key}"
    aws_secret_key = "${var.secret_key}"
  }
}

data "template_file" "aws_config" {
  template = "${file("${path.module}/files/aws_config")}"

  vars {
    region = "${var.region}"
  }
}
