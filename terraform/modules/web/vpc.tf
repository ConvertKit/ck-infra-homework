/* Define our vpc */
resource "aws_vpc" "web_app_vpc" {
  cidr_block = "${var.web_vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "web_app_vpc"
  }
}

/* Create an internet gateway to connect to */
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.web_app_vpc.id}"

  tags {
    Name = "Web App IG"
  }
}


/* Provider Subenets */
resource "aws_subnet" "web_subnet_a" {
    vpc_id = "${aws_vpc.web_app_vpc.id}"
    cidr_block = "${var.web_subnet_a}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags {
        Name = "Web Subnet Zone A"
    }
}

resource "aws_subnet" "web_subnet_b" {
    vpc_id = "${aws_vpc.web_app_vpc.id}"
    cidr_block = "${var.web_subnet_b}"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags {
        Name = "Web Subnet Zone B"
    }
}

resource "aws_subnet" "web_subnet_c" {
    vpc_id = "${aws_vpc.web_app_vpc.id}"
    cidr_block = "${var.web_subnet_c}"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    tags {
        Name = "Web Subnet Zone C"
    }
}

# Create a route table for web vpc
data "aws_route_table" "web_route_table" {
    vpc_id = "${aws_vpc.web_app_vpc.id}"
}

// Associate the subnets a-c
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.web_subnet_a.id}"
  route_table_id = "${data.aws_route_table.web_route_table.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.web_subnet_b.id}"
  route_table_id = "${data.aws_route_table.web_route_table.id}"
}

resource "aws_route_table_association" "c" {
  subnet_id      = "${aws_subnet.web_subnet_c.id}"
  route_table_id = "${data.aws_route_table.web_route_table.id}"
}

// associate internet gateway
resource "aws_route" "web_public_internet" {
  route_table_id         = "${data.aws_route_table.web_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}
