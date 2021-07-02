variable "region" {
  type        = string
  description = "AWS West Region"
  default     = "us-west-1" #us-east-1
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

output "lb_dns" {
  value = aws_lb.alb.dns_name
}
