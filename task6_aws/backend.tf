terraform {
  backend "s3" {
    bucket = "mario-terraform-states"
    key    = "dev/ec2_new.tfstate"
    region = "us-west-1"
  }
}
