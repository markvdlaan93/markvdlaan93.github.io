variable "aws_ec2_access_key" {}
variable "aws_ec2_secret_key" {}
variable "aws_region" {}
variable "aws_ami_ubuntu_server_16_04_lts" {
    default = "ami-0987ee37af7792903"
}

provider "aws" {
    access_key  = "${var.aws_ec2_access_key}"
    secret_key  = "${var.aws_ec2_secret_key}"
    region      = "${var.aws_region}"
    version     = "~> 2.0"
}

resource "aws_instance" "example" {
    ami = "${var.aws_ami_ubuntu_server_16_04_lts}"
    instance_type = "t2.micro"
    tags {
        Name = "example"
    }
}