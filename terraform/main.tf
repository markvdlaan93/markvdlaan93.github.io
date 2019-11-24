variable "AWS_USER_ACCESS_KEY" {}
variable "AWS_USER_SECRET_KEY" {}
variable "AWS_REGION" {}
variable "AWS_AMI_UBUNTU_SERVER_16_04_LTS" {
    default = "ami-0987ee37af7792903"
}

provider "aws" {
    access_key  = "${var.AWS_USER_ACCESS_KEY}"
    secret_key  = "${var.AWS_USER_SECRET_KEY}"
    region      = "${var.AWS_REGION}"
}

resource "aws_instance" "example" {
    ami = "${var.AWS_AMI_UBUNTU_SERVER_16_04_LTS}"
    instance_type = "t2.micro"
    tags {
        Name = "example"
    }
}