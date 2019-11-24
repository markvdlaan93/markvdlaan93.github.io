variable "AWS_USER_ACCESS_KEY" {}
variable "AWS_USER_SECRET_KEY" {}
variable "AWS_REGION" {}

provider "aws" {
    access_key  = "${var.AWS_USER_ACCESS_KEY}"
    secret_key  = "${var.AWS_USER_SECRET_KEY}"
    region      = "${var.AWS_REGION}"
}