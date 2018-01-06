terraform {
  backend "s3" {
    key = "terraform/terraform.tfstate"
  }
}

variable "bucket_prefix" {
  type = "string"
}

provider "aws" {}

resource "aws_s3_bucket" "blog_contents" {
  bucket = "${var.bucket_prefix}-blog-contents"
  acl    = "public-read"
}
