provider "aws" {
    access_key  = "${var.aws_ec2_access_key}"
    secret_key  = "${var.aws_ec2_secret_key}"
    region      = "${var.aws_region}"
    profile     = "${var.aws_profile}"
    version     = "~> 2.0"
}

# Backend configurations can't be interpolated by variables. Therefore, use hardcoded stringss
terraform {
  backend "s3" {
    bucket          = "mvdlaan93-tfstate"
    key             = "states/terraform.tfstate"
    region          = "eu-west-1"
  }
}

# resource "aws_instance" "example" {
#     ami = "${var.aws_ami_ubuntu_server_16_04_lts}"
#     instance_type = "t2.micro"
#     tags {
#         Name = "example"
#     }
# }