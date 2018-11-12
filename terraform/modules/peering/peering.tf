# Get web route table
data "aws_route_table" "web_route_table" {
    vpc_id = "${var.web_vpc_id}"
}

# Get db route table
data "aws_route_table" "db_route_table" {
    vpc_id = "${var.db_vpc_id}"
}

# peer connection between web and db
resource "aws_vpc_peering_connection" "web_to_db" {
  vpc_id = "${var.web_vpc_id}"
  peer_vpc_id = "${var.db_vpc_id}"
  auto_accept = true
}


# Create web to db route
resource "aws_route" "web_to_db" {
  route_table_id = "${data.aws_route_table.web_route_table.id}"
  destination_cidr_block = "${var.db_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.web_to_db.id}"
}

resource "aws_route" "db_to_web" {
  route_table_id = "${data.aws_route_table.db_route_table.id}"
  destination_cidr_block = "${var.web_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.web_to_db.id}"
}
