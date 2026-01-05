terraform {
  backend "s3" {
    bucket = "terraform-state-backend1346789"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}