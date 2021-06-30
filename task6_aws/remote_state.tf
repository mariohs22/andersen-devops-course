data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.terraform_state_bucket
    key    = format("%s/ec2_new.tfstate", var.env)
    region = var.terraform_state_bucket_region
  }
}
