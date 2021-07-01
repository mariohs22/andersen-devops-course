variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-west-1"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "subnet_00_cidr" {
  description = "subnet00 cidr block"
  type        = string
  default     = "172.16.1.0/24"
}

variable "subnet_01_cidr" {
  description = "subnet01 cidr block"
  type        = string
  default     = "172.16.2.0/24"
}


variable "zones" {
  default = {
    zone0 = "us-west-1b"
    zone1 = "us-west-1c"
  }
}

variable "cidr_blocks" {
  default = {
    zone0 = "172.16.1.0/24"
    zone1 = "172.16.2.0/24"
  }
}





variable "instance_type" {
  description = "Please chose instance type"
  type        = string
  default     = "t2.nano"
}

variable "ec2_tags" {
  type = map(any)
  default = {
    Name = "task6_server"
  }
}

# variable "ec2_amis" {
#   type = map
#   default = {
#     eu-west-1 = "ami-0fc970315c2d38f01"
#     eu-west-2 = "ami-098828924dc89ea4a"
#   }
# }

variable "task6_s3_bucket" {
  type    = string
  default = "task6-bucket-202107"
}




variable "env" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project prefix"
  type        = string
  default     = "task6"
}

variable "service" {
  description = "Service Name"
  type        = string
  default     = "example"
}

variable "contact" {
  description = "Owner Name"
  type        = string
  default     = "1880118@gmail.com"
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
