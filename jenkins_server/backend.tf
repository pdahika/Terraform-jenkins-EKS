terraform {
  backend "s3" {
    bucket = "terraform-state-backend1346789"
    key    = "terraform.tf"
    region = "us-east-1"
  }
}