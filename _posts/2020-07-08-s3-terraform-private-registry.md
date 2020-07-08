---
layout: post
title: Create AWS S3 private Terraform module registry
subtitle: Exploitation techniques with gdb
image:
tags: Amazon Web Services, S3, Terraform, registry
---

## Overview

Terraform modules are useful for grouping multiple resources together. Anyone that have been written serious amounts of code in Terraform, knows that modules are indispensable. In many corporate setups, Terraform code isn't necessarily stored in the same (Git) repository. In that case, dedicated storage becomes useful for collecting Terraform modules used throughout the organization. In this tutorial, I will explain how to setup a versioned deployment process towards AWS S3.

## Terraform dummy module

In order to store a module, it is necessary to create one. Lets create some generic configurations and a security group:
```
terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.7"

  region = var.region
}

variable "vpc_id" {}

resource "aws_security_group" "security_group_test" {
  name = "test-sg"
  description = "Test security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Environment = "Test"
  }
}

output "sg_name" {
  value = "${aws_security_group.security_group_test.name}"
}

output "sg_arn" {
  value = "${aws_security_group.security_group_test.arn}"
}

output "sg_id" {
  value = "${aws_security_group.security_group_test.id}"
}
```

## Python scripts for deploying versioned version

This is Python code you can use to deploy a versioned version to S3:
```
import os
import sys
import boto3
import shutil
import glob
from botocore.errorfactory import ClientError

def get_current_version(s3, bucket, version_file):
    """
    Get current version from file in S3 bucket. If this file, doesn't exist
    it will be created with version 0.0.0
    """
    try:
        s3.head_object(Bucket=bucket, Key=version_file)
    except ClientError:
        upload_new_version_file(s3)
    
    data = s3.get_object(Bucket=bucket, Key=version_file)
    return data['Body'].read()

def upload_new_version_file(s3):
    """
    Uploads non-existing version file.
    """
    with open('/.NEW_VERSION_FILE', 'rb') as data:
        s3.upload_fileobj(data, bucket, version_file)

def get_release_version(current_version, version_option):
    """
    Based on version option (patch, minor or major) a new version is returned.
    For example:
    - Patch version: 1.2.3 -> 1.2.4
    - Minor version: 1.2.3 -> 1.3.3
    - Major version: 1.2.3 -> 2.2.3
    """
    current_version = current_version.decode().split(".")
    new_version = None
    if version_option == 'PATCH':
        current_patch_version = int(current_version[2])
        current_patch_version += 1
        new_version = [current_version[0], current_version[1], str(current_patch_version)]
    
    if version_option == 'MINOR':
        current_minor_version = int(current_version[1])
        current_minor_version += 1
        new_version = [current_version[0], str(current_minor_version), current_version[2]]
    
    if version_option == 'MAJOR':
        current_major_version = int(current_version[0])
        current_major_version += 1
        new_version = [str(current_major_version), current_version[1], current_version[2]]

    return '.'.join(new_version)

def upload_new_version(release_version, source_directory, target_directory):
    """
    Takes files from parent directory, zips them and store the zip into the
    S3 bucket. 
    """
    def make_archive(source, no_format_destination, format):
        archive_from = os.path.dirname(source)
        archive_to = os.path.basename(source.strip(os.sep))
        shutil.make_archive(no_format_destination, format, archive_from, archive_to)
        shutil.move('%s.%s'%(no_format_destination,format), no_format_destination)
    
    os.mkdir(target_directory)

    # Fetch all Terraform files from directory
    for filename in glob.glob(os.path.join(source_directory, '*.tf')):
        shutil.copy(filename, target_directory)

    make_archive(target_directory, os.path.join(target_directory, release_version), 'zip')

    bucket = os.environ.get('S3_BUCKET')
    version_file = os.environ.get('S3_VERSION_FILE')

    if bucket is None or version_file is None:
        raise ValueError('Please add environment variables.')
        sys.exit(0)

    with open('/tmp/'+release_version+'.zip', 'rb') as data:
        s3.upload_fileobj(data, bucket, version_file)

s3_access_key    = os.environ.get('S3_ACCESS_KEY')
s3_access_secret = os.environ.get('S3_ACCESS_SECRET')
bucket           = os.environ.get('S3_BUCKET')
version_file     = os.environ.get('S3_VERSION_FILE')
version_option   = os.environ.get('VERSION_OPTION')
source_directory = os.environ.get('SOURCE_DIRECTORY')
target_directory = os.environ.get('TARGET_DIRECTORY')

if (s3_access_key  is None or s3_access_secret is None or 
    bucket         is None or version_file     is None or
    version_option is None):
    raise ValueError('Please add environment variables.')
    sys.exit(0)

if version_option not in ['PATCH', 'MINOR', 'MAJOR']:
    raise ValueError('VERSION_OPTION can only have values PATCH, MINOR or MAJOR')
    sys.exit(0)

s3 = boto3.client(
    's3',
    aws_access_key_id=s3_access_key,
    aws_secret_access_key=s3_access_secret
)

current_version = get_current_version(s3)
release_version = get_release_version(current_version, version_option)
upload_new_version(release_version, source_directory, target_directory)
```

For versioning, this script uses a file which is stored in the same S3 bucket. Other mechanism, like Git tags could also be used but I wanted to create a platform independent solution. There are three version options: patch, minor and major.

## Use versioned Terraform module in other code

When you've uploaded the Terraform module to S3, it should be accessible from another piece of Terraform code:
```
```

Please make sure that the AWS access key and secret have enough permissions to read from the S3 bucket.