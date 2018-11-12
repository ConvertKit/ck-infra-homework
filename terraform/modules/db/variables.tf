variable "username" {
  description = "db username"
}

variable "password" {
  description = "db password"
}

variable "db_name" {
  description = "db name"
}

variable "instance_class" {
  description = "db instance class"
}

variable "engine_version" {
  description = "db engine version"
}

variable "engine" {
  description = "db engine"
}

variable "storage_type" {
  description = "storage type"
}

variable "allocated_storage" {
  description = "amount of storage"
}

variable "db_vpc_cidr" {
  description = "rds vpc"
}

variable "db_subnet_a" {
  description = "subnet a"
}

variable "db_subnet_b" {
  description = "subnet b"
}
variable "db_subnet_c" {
  description = "subnet c"
}

variable "web_vpc_cidr" {
  description = "cidr of application"
}
