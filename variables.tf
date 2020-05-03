variable "aws_access_key" {
  description = "The aws_access_key"
  default = ""
}

variable "aws_secret_key" {
  description = "The aws_secret_key"
  default = ""
}

variable "aws_keypair_name" {
  default = "amitthk_jenkinsmaster"
}

variable "region" {
  description = "The AWS region to deploy to"
  default = "ap-southeast-1"
}

variable "instance_type" {
  description = "The AMI Type"
  default = "t2.micro"
}

 variable "default_vpc_id" {
   description = "default_vpc_id"
   default = "vpc-6f4d330b"
 }

variable "hadoop_stack_name" {
  description = "The name of the deployment stack"
  default = "hdpsparkstack"
}

variable "ami_id" {
    description = "AMI Id"
    default = "ami-8e0205f2"
}

variable "public_subnets_cidr_blocks" {
  description = "public_subnets_cidr_blocks"
  default = ""
}

variable "private_subnets_cidr_blocks" {
  description = "private_subnets_cidr_blocks"
  default = ""
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "172.31.0.0/16"
}

variable "reserved_hdpspark_master_count"{
  description = "reserved_hdpspark_master_count"
  default = 1
}

variable "master_block_device_size"{
  description = "master_block_device_size"
  default = 80
}
variable "spot_hdpspark_master_count" {
  description = "hdpspark_master_count"
  default = 1
}

variable "spot_hdpspark_worker_count" {
  description = "hdpspark_worker_count"
  default = 3
}

variable "spot_hdpspark_gateway_count" {
  description = "hdpspark_gateway_count"
  default = 1
}

variable "spot_price" {
  description = "spot_price"
  default = 0.0045
}

variable "ingress_from_port" {
  description = "ingress_from_port"
  default = 0
}

variable "ingress_to_port" {
  description = "ingress_to_port"
  default = 0
}

variable "availability_zone" {
  description = "availability_zone"
  default = "ap-southeast-1a"
}