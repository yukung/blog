terraform {
  backend "gcs" {
    prefix = "terraform/terraform.tfstate"
  }
}

variable "domain_name" {
  type = "string"
}

provider "google" {
  version = "~> 3.4.0"
}

resource "google_storage_bucket" "blog_images" {
  name = "images.${var.domain_name}"
  location = "US-WEST1"
  storage_class = "REGIONAL"
}

resource "google_storage_bucket_iam_binding" "blog_executor_bucket_policy_binding" {
  bucket = "${google_storage_bucket.blog_images.name}"
  role = "roles/storage.legacyBucketWriter"
  members = [
    "serviceAccount:${google_service_account.blog_executor.email}"
  ]
}

resource "google_storage_bucket_iam_member" "blog_viewer" {
  bucket = "${google_storage_bucket.blog_images.name}"
  role = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

resource "google_service_account" "blog_executor" {
  account_id = "blog-executor"
  display_name = "Blog Service Account"
}
