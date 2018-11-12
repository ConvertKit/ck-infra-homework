
resource "aws_db_instance" "web_db" {
  depends_on           = ["aws_vpc.rds_vpc"]
  allocated_storage    = "${var.allocated_storage}"
  storage_type         = "${var.storage_type}"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.username}"
  password             = "${var.password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_vpc_group.id}"
  skip_final_snapshot  = true
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
}
