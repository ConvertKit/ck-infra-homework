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

variable "key_name" {
  description = "Key for ssh"
}

variable "asgname" {
  description = "Name for autoscaling group"
}

variable "min_size" {
  description = "minimum size of asg"
}

variable "max_size" {
  description = "max size of asg"
}

variable "amisize" {
  description = "instance size"
}

variable "docker_image" {
  description = "docker image to run"
}

variable "docker_tag" {
  description = "docker tag to run"
}

variable "docker_port" {
  description = "port of application to expose"
}

variable "rake_secret" {
  description = "rake secret to run rails"
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

variable "db_endpoint" {
  description = "db endpoint"
}

variable "access_key" {
  description = "aws access key"
}

variable "secret_key" {
  description = "aws secret key"
}
