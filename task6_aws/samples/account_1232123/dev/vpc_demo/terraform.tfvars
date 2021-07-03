cidr               = "10.239.128.0/21"
public_subnets     = ["10.239.128.0/25", "10.239.128.128/25"]
private_subnets    = ["10.239.130.0/24", "10.239.131.0/24"]
azs                = ["eu-central-1a", "eu-central-1b"]
single_nat_gateway = false
enable_dns_support = true
enable_dns_hostnames = true