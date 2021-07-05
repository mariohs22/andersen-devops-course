module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  name           = "my-vpc"
  cidr           = var.vpc_cidr
  azs            = var.azs
  public_subnets = var.subnet_cidr
}

# module "ssh-bastion-service" {
#   source                        = "joshuamkite/ssh-bastion-service/aws"
#   aws_region                    = var.region
#   vpc                           = module.vpc.vpc_id
#   subnets_asg                   = module.vpc.public_subnets
#   subnets_lb                    = module.vpc.public_subnets
#   cidr_blocks_whitelist_service = ["0.0.0.0/0"]
#   public_ip                     = true
#   depends_on = [
#     module.vpc,
#   ]
# }
