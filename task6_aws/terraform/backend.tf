terraform {
  required_version = ">=0.14.0"

  backend "s3" {
    bucket = "mario-terraform-states"
    key    = "task6.tfstate"
    region = "us-west-1"
  }
}
