provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

variable "users" {
  default = ["santino", "michael", "fredo"]
}

variable "num_of_buckets" {
  default = 3
}

variable "s3_bucket_name" {
  default = "simaox-test-bucket"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "${var.s3_bucket_name}-${element(var.users, count.index)}"
  count = var.num_of_buckets
}

