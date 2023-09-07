# Run the backend.tf file before running this file
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket         = "tf-remote-s3-bucket-simaox"
    key            = "env/dev/tf-remote-backend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt        = true
  }
}

locals {
  mytag = "simaox-local"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["simaox-terraform-ami"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

variable "ec2_type" {
  default = "t2.micro"
}

# resource "aws_instance" "tf-ec2" {
#   ami           = data.aws_ami.tf_ami.id
#   instance_type = var.ec2_type
#   key_name      = "first-key-pair"
#   tags = {
#     Name = "${local.mytag}-instance-from-AMI"
#   }
# }

resource "aws_s3_bucket" "tf-remote-state" {
  bucket        = "tf-remote-s3-bucket-simaox-new"
  force_destroy = true
  # to prevent accidental deletion of the content of a bucket
  # the value should be false
}