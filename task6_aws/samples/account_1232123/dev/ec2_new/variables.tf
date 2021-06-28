variable "instance_type" {
  description = "instance type for my ec2 instance"
  default     = "t2.small"
  type        = string
}

variable "cidr_to_allow" {
  default = "0.0.0.0/0"
}