//  Create a security group allowing web access to the public subnet.
resource "aws_security_group" "web-app-sg" {
  name        = "web app sg"
  description = "Security group that allows web traffic from internet"
  vpc_id      = "${aws_vpc.web_app_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "Web app public"
    Project = "web-app"
  }
}

resource "aws_security_group" "efs-sg" {
  name        = "efs sg"
  description = "Security group that allows traffic from efs"
  vpc_id      = "${aws_vpc.web_app_vpc.id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self = true
  }

  egress {
    from_port = "2049"
    to_port   = "2049"
    protocol  = "tcp"
    self = true
  }

  tags {
    Name    = "efs"
    Project = "efs"
  }
}
