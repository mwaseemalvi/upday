# terraform plan -var-file terraform.tfvars

# Define AWS provider
# ==============================================================

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

# Resources - VPC
# ==============================================================

# Create VPC
resource "aws_vpc" "upday" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  
}

# Setup the public subnet - on US-East-1A AZ
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.upday.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"

  
}

# NAT Gateway for Internet access for Private Subnet
# =========================================================
resource "aws_eip" "gateway_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.gateway_eip.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  depends_on    = ["aws_internet_gateway.gw"]
  
  
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.upday.id}"
}  

resource "aws_route" "nat_route" {
  route_table_id         = "${aws_route_table.nat_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gateway.id}"  
}

resource "aws_route_table_association" "private_route" {  
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}

# Resources - EC2 Instances
# ==============================================================
# Setup webserver on public subnet
resource "aws_instance" "wb" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-public.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("install_web.sh")}"

  tags {
    Name = "webserver"
  }
}

# setup Jenkins Server on private subnet
resource "aws_instance" "jenkins" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-private.id}"]
   source_dest_check = false
   user_data = "${file("install_jenkins.sh")}"

  tags {
    Name = "jenkins"
  }
}