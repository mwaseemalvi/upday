# VARIABLES
# =======================================
# From TerraForm.tfvars file
variable "aws_access_key" {}
variable "aws_secret_key" {}



variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

# Other Variables
# =======================================
variable "vpc_cidr" {
  description = "VPC CIDR"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet - CIDR"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet - CIDR"
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "EC2 AMI"
  default = "ami-009d6802948d06e52"
}

variable "key_name" {
  description = "AWS SSH Key Name"
  default = "upday"
}

variable "instance_username" { 
  default = "ec2-user" 
} 

variable "instance_password" { }
