output "db_vpc_id" {
  value = "${aws_vpc.rds_vpc.id}"
}

output "db_endpoint" {
  value = "${aws_db_instance.web_db.address}"
}
