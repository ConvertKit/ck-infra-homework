/* Define our vpc */
resource "aws_vpc" "rds_vpc" {
  cidr_block = "${var.db_vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "rds_vpc"
  }
}

/* Provider Subenets */
resource "aws_subnet" "db_subnet_a" {
    depends_on = ["aws_vpc.rds_vpc"]
    vpc_id = "${aws_vpc.rds_vpc.id}"
    cidr_block = "${var.db_subnet_a}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags {
        Name = "RDS Subnet A"
    }
}

resource "aws_subnet" "db_subnet_b" {
    depends_on = ["aws_vpc.rds_vpc"]
    vpc_id = "${aws_vpc.rds_vpc.id}"
    cidr_block = "${var.db_subnet_b}"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags {
        Name = "RDS Subnet B"
    }
}

resource "aws_subnet" "db_subnet_c" {
    depends_on = ["aws_vpc.rds_vpc"]
    vpc_id = "${aws_vpc.rds_vpc.id}"
    cidr_block = "${var.db_subnet_c}"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    tags {
        Name = "RDS Subnet C"
    }
}

# Get a route table for rds vpc
data "aws_route_table" "rds_route_table" {
    vpc_id = "${aws_vpc.rds_vpc.id}"
}

// Associate the subnets a-c
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.db_subnet_a.id}"
  route_table_id = "${data.aws_route_table.rds_route_table.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.db_subnet_b.id}"
  route_table_id = "${data.aws_route_table.rds_route_table.id}"
}

resource "aws_route_table_association" "c" {
  subnet_id      = "${aws_subnet.db_subnet_c.id}"
  route_table_id = "${data.aws_route_table.rds_route_table.id}"
}

resource "aws_db_subnet_group" "rds_vpc_group" {
  name       = "rds"
  subnet_ids = ["${aws_subnet.db_subnet_a.id}", "${aws_subnet.db_subnet_b.id}", "${aws_subnet.db_subnet_c.id}"]

  tags {
    Name = "DB subnet group"
  }
}
