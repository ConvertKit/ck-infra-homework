//  Create a security group allowing app access to databas.
resource "aws_security_group" "db_sg" {
  name        = "db security group"
  description = "Security group that allows app access"
  vpc_id      = "${aws_vpc.rds_vpc.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.web_vpc_cidr}"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["${var.web_vpc_cidr}"]
  }

  tags {
    Name    = "db security group"
    Project = "database"
  }
}
