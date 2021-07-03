variable "region" {
  type        = string
  description = "AWS West Region"
  default     = "us-west-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(any)
  description = "Availability Zones"
  default     = ["us-west-1b", "us-west-1c"]
}

variable "subnet_cidr" {
  type        = list(any)
  description = "VPC Subnet CIDR Ranges"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}


variable "s3_bucket_http_name" {
  type        = string
  description = "S3 bucket name with http directory"
  default     = "task6-http"
}
