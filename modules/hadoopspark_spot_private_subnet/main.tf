
resource "aws_vpc" "primary" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
      tags {
        Name = "hdpsparkstack-aws-vpc"
    }
}
resource "aws_security_group" "hdpsparkstack" {
  name = "${format("%s-app-sg", var.hadoop_stack_name)}"

  vpc_id = "${aws_vpc.primary.id}"

  ingress {
    from_port   = "${var.ingress_from_port}"
    to_port     = "${var.ingress_to_port}"
    protocol    = "tcp"
    cidr_blocks = ["${list(var.public_subnets_cidr_blocks)}", "${list(var.private_subnets_cidr_blocks)}"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnets_cidr_blocks}"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "8600"
    to_port     = "8600"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "8300"
    to_port     = "8302"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "8500"
    to_port     = "8502"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "4646"
    to_port     = "4648"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "4200"
    to_port     = "4205"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8000"
    to_port     = "8000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8080"
    to_port     = "8090"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "19998"
    to_port     = "20004"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "29998"
    to_port     = "30003"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8888"
    to_port     = "8890"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  
  tags {
    Group = "${var.hadoop_stack_name}"
  }
}


# resource "aws_subnet" "hdpspark_private_subnet" {
#   vpc_id = "${var.vpc_id}"
#   cidr_block = "${var.private_subnets_cidr_blocks}"
#   availability_zone = "${var.availability_zone}"

#   tags = {
#     Name = "hdpspark_private_subnet"
#   }
# }


resource "aws_subnet" "public_nat_1" {
  cidr_block = "${var.public_subnets_cidr_blocks}"
  vpc_id = "${aws_vpc.primary.id}"
  availability_zone = "${var.availability_zone}"

  tags {
    Name = "Nat #1"
    Visibility = "Public"
  }
}
resource "aws_subnet" "private_nat_1" {
  cidr_block = "${var.private_subnets_cidr_blocks}"
  vpc_id = "${aws_vpc.primary.id}"
  availability_zone = "${var.availability_zone}"

  tags {
    Name = "Nat #1"
    Visibility = "Public"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.primary.id}"
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.primary.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "rta" {
  count = "${length(var.public_subnets_cidr_blocks)}"
  subnet_id      = "${aws_subnet.public_nat_1.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}


# resource "aws_vpc" "secondary" {
#   cidr_block = "${var.private_subnets_cidr_blocks}"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

# }

resource "aws_route53_zone" "intranet" {
  name = "intranet.amitthk.com"

  # NOTE: The aws_route53_zone vpc argument accepts multiple configuration
  #       blocks. The below usage of the single vpc configuration, the
  #       lifecycle configuration, and the aws_route53_zone_association
  #       resource is for illustrative purposes (e.g. for a separate
  #       cross-account authorization process, which is not shown here).
  vpc {
    vpc_id = "${aws_vpc.primary.id}"
    vpc_region = "${var.region}"
  }
  comment = "${format("%s-private-hosted-zone", var.hadoop_stack_name)}"

  lifecycle {
    ignore_changes = ["vpc"]
  }
}

# resource "aws_route53_zone_association" "primary" {
#   zone_id = "${aws_route53_zone.intranet.zone_id}"
#   vpc_id  = "${aws_vpc.primary.id}"
# }
