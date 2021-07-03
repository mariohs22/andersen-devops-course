terraform {
  backend "s3" {
    bucket         = "demo-non-prod-terraform-states"
    key            = "dev/ec2_new.tfstate"
    region         = "eu-central-1"
    #dynamodb_table = "terraform-state-lock"
  }
}