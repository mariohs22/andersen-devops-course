terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02f24ad9a1d24a799"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}