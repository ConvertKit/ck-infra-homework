resource "aws_efs_file_system" "web_efs" {

  tags {
    Name = "Web EFS"
  }
}

resource "aws_efs_mount_target" "a" {
  file_system_id = "${aws_efs_file_system.web_efs.id}"
  subnet_id      = "${aws_subnet.web_subnet_a.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

resource "aws_efs_mount_target" "b" {
  file_system_id = "${aws_efs_file_system.web_efs.id}"
  subnet_id      = "${aws_subnet.web_subnet_b.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

resource "aws_efs_mount_target" "c" {
  file_system_id = "${aws_efs_file_system.web_efs.id}"
  subnet_id      = "${aws_subnet.web_subnet_c.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}
