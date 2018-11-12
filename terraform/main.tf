// main.tf
// Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "web" {
  source          = "./modules/web"
  region          = "${var.region}"
  web_vpc_cidr    = "${var.web_vpc_cidr}"
  web_subnet_a    = "${var.web_subnet_a}"
  web_subnet_b    = "${var.web_subnet_b}"
  web_subnet_c    = "${var.web_subnet_c}"
  ec2_ami         = "${var.ec2_ami}" // This is the ubuntu 14.04 AMI in the us-east-1 region with awscli and docker installed
  amisize         = "t2.micro"
  min_size        = "${var.web_asg_min_size}"
  max_size        = "${var.web_asg_max_size}"
  key_name        = "test"
  asgname         = "web-asg"
  docker_image    = "${var.web_docker_image}"
  docker_tag      = "${var.web_docker_tag}"
  docker_port     = "${var.web_docker_port}"
  rake_secret     = "${var.web_rake_secret}"
  db_endpoint     = "${module.db.db_endpoint}"
  db_name         = "${var.db_name}"
  db_username     = "${var.db_username}"
  db_password     = "${var.db_password}"
  access_key      = "${var.aws_access_key}"
  secret_key      = "${var.aws_secret_key}"
}

module "db" {
  source          = "./modules/db"
  allocated_storage    = "${var.db_allocated_storage}"
  storage_type         = "${var.db_storage_type}"
  engine               = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  instance_class       = "${var.db_instance_class}"
  db_name              = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  db_vpc_cidr          = "${var.db_vpc_cidr}"
  db_subnet_a          = "${var.db_subnet_a}"
  db_subnet_b          = "${var.db_subnet_b}"
  db_subnet_c          = "${var.db_subnet_c}"
  web_vpc_cidr         = "${var.web_vpc_cidr}"
}

module "peering" {
  source        = "./modules/peering"
  db_vpc_id     = "${module.db.db_vpc_id}"
  web_vpc_id    = "${module.web.web_vpc_id}"
  db_vpc_cidr   = "${var.db_vpc_cidr}"
  web_vpc_cidr  = "${var.web_vpc_cidr}"
}

output "db_url" {
  value = "${module.db.db_endpoint}"
}

output "loadbalancer" {
  value = "${module.web.web_nlb_address}"
}
