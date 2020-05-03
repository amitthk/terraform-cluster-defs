module "hdpsparkstack_reserved" {
  source = "./modules/hadoopspark_reserved"

  spot_price = "${var.spot_price}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_keypair_name = "${var.aws_keypair_name}"
  region = "${var.region}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.instance_type}"
  default_vpc_id = "${var.default_vpc_id}"
  hadoop_stack_name = "${var.hadoop_stack_name}"
  ami_id = "${var.ami_id}"
  public_subnets_cidr_blocks = "${var.public_subnets_cidr_blocks}"
  private_subnets_cidr_blocks = "${var.private_subnets_cidr_blocks}"
  spot_hdpspark_master_count = "${var.spot_hdpspark_master_count}"
  spot_hdpspark_worker_count = "${var.spot_hdpspark_worker_count}"
  spot_hdpspark_gateway_count = "${var.spot_hdpspark_gateway_count}"
  reserved_hdpspark_master_count = "${var.reserved_hdpspark_master_count}"
  ingress_from_port = "${var.ingress_from_port}"
  ingress_to_port = "${var.ingress_to_port}"
  vpc_cidr = "${var.vpc_cidr}"
  master_block_device_size = "${var.master_block_device_size}"
}

terraform{
  backend "s3" {
  }
}