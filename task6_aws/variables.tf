variable "AWS_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "EC2_instances_ami" {
  description = "AMI for EC2 instances for us-west-1 region"
  type        = string
  default     = "ami-02f24ad9a1d24a799"
}

variable "EC2_instance1_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "EC2_Instance1"
}

variable "EC2_instance2_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "EC2_Instance2"
}
