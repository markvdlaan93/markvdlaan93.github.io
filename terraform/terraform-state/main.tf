provider "aws" {
    access_key  = "${var.aws_ec2_access_key}"
    secret_key  = "${var.aws_ec2_secret_key}"
    region      = "${var.aws_region}"
    version     = "~> 2.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "mvdlaan93-tfstate"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}