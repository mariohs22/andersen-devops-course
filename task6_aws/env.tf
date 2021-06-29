# Specify the provider and access details
provider "aws" {
  region  = var.region
  profile = "default"
}

data "aws_caller_identity" "current" {}

variable "region" {
  description = "default aws region"
  type        = string
  default     = "us-west-1"
}

variable "terraform_state_bucket" {
  description = "bucket for remote states"
  type        = string
  default     = "demo-non-prod-terraform-states"
}

variable "terraform_state_bucket_region" {
  description = "default aws region"
  type        = string
  default     = "eu-central-1"
}

variable "env" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "Domain to join machine"
  type        = string
  default     = "cloud.local"
}

variable "project" {
  description = "Project prefix"
  type        = string
  default     = "proj"
}

variable "service" {
  description = "Service Name"
  type        = string
  default     = "example"
}

variable "contact" {
  description = "Owner Name"
  type        = string
  default     = "owner@mail.com"
}

locals {
  tags = {
    Environment = var.env
    Service     = var.service
    Contact     = var.contact
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}
