variable "aws_access_key" {
  description = "AWS access Key"
}
variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "region" {
    description = "EC2 Region for the VPC"
}

variable "ec2_ami" {
    description = "AMIs by region"
}

variable "web_subnet_a" {
  description = "cidr by az"
}

variable "web_subnet_b" {
  description = "cidr by az"
}
variable "web_subnet_c" {
  description = "cidr by az"
}

variable "web_vpc_cidr" {
  description = "VPC CIDR for web app"
}

variable "web_asg_min_size" {
  description = "minimum size of asg"
}

variable "web_asg_max_size" {
  description = "max size of asg"
}

variable "db_username" {
  description = "db username"
}

variable "db_password" {
  description = "db password"
}

variable "db_name" {
  description = "db name"
}

variable "db_instance_class" {
  description = "db instance class"
}

variable "db_engine_version" {
  description = "db engine version"
}

variable "db_engine" {
  description = "db engine"
}

variable "db_storage_type" {
  description = "storage type"
}

variable "db_allocated_storage" {
  description = "amount of storage"
}

variable "db_vpc_cidr" {
  description = "db_vpc_cidr"
}

variable "db_subnet_a" {
  description = "cidr by az"
}

variable "db_subnet_b" {
  description = "cidr by az"
}
variable "db_subnet_c" {
  description = "cidr by az"
}

variable "web_docker_image" {
  description = "docker image to run"
}

variable "web_docker_tag" {
  description = "docker tag to run"
}

variable "web_docker_port" {
  description = "port of application to expose"
}

variable "web_rake_secret" {
  description = "rake secret to run rails"
}
