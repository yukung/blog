variable "bucket-prefix" {
  type = "string"
}

provider "aws" {}

resource "aws_s3_bucket" "blog-contents" {
  bucket = "${var.bucket-prefix}-blog-contents"
  acl    = "public-read"
}
