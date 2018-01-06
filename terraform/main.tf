terraform {
  backend "s3" {
    key = "terraform/terraform.tfstate"
  }
}

variable "bucket_name_suffix" {
  type = "string"
}

provider "aws" {}

resource "aws_s3_bucket" "blog_images" {
  bucket = "images-${var.bucket_name_suffix}"
  acl    = "public-read"
}
