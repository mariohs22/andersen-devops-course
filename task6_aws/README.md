## Task description

### IaC template

#### Write AWS CloudFormation / Terraform template for this diagram

![IaC diagram](task6_diagram.png)

#### Additional

- Do the same in **Azure ARM** or **GCP Deploy Manager** and redraw the diagram
- Update **AWS** diagram, add missed instances
- Add **AWS EC2** **AutoRecovery** option
- Write the script-wrapper that have the ability to run different **Envs** with the different options

### Hints

- [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html)
- [https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
- [https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)
- [https://cloud.google.com/deployment-manager/docs](https://cloud.google.com/deployment-manager/docs)
- [https://en.wikipedia.org/wiki/Infrastructure_as_code](https://en.wikipedia.org/wiki/Infrastructure_as_code)
- [https://www.terraform.io/docs/providers/index.html](https://www.terraform.io/docs/providers/index.html)
- [https://www.terraform.io/docs/index.html](https://www.terraform.io/docs/index.html)
- [https://registry.terraform.io/browse/providers](https://registry.terraform.io/browse/providers)

### Prerequisites

To follow this task you will need:

- The [Terraform CLI](https://www.terraform.io/downloads.html) installed.
- The [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed.
- [An AWS account](https://aws.amazon.com/free/).
- Your AWS credentials. You can [create a new Access Key on this page](https://console.aws.amazon.com/iam/home?#/security_credentials).

Configure the AWS CLI and Terraform from your terminal.

```
aws configure
terraform init
```

You can format and validate the configuration files by using these commands:

```
terraform fmt
terraform validate
```

## Task explanation

Terraform files of this task are based in `/terraform` subdir:

- `provider.tf` - setting up Amazon AWS terraform provider.
- `backend.tf` - setting up Amazon S3 bucket as backend.
- `variables.tf` - setting up some variables: AWS region, EC2 instance type, S3 bucket name, CIDRs of VPC and subnets;
- `vpc.tf` - create VPC (virtual private cloud) resource on AWS. This section uses [AWS VPC Terraform module](https://github.com/terraform-aws-modules/terraform-aws-vpc) to create VPC `10.0.0.0/16` and two subnets (`10.0.101.0/24` and `10.0.102.0/24`) in different zones (`us-west-1b` and `us-west-1c`), you can easily change it in `variables.tf`.
- `sg.tf` - used to create security group (open ports for http, https, ssh incomming connections, allow any outgoing connections).
- `s3.tf` - used to create new private S3 bucket and upload to it own _index.html_ file: `/scripts/index.html`.
- `ec2.tf` - used to create EC2 instances in different zones (count of inctances depends on `variables.tf` settings) with Amazon linux2 installed, execute the script file `/scripts/install.sh` after creation instance to install nginx and replace default `index.html` from S3.
- `aim.tf` -setting up IAM (Identity and Access Management) to access private S3 bucket.
- `load_balancer.tf` - setting up application load balancer.
- `output.tf` - outputs DNS name for access our load balancer (EC2 instances) from internet.

<details>
    <summary>Terraform plan</summary>
    Terraform will perform the following actions:

    # aws_iam_instance_profile.ec2_profile will be created
    + resource "aws_iam_instance_profile" "ec2_profile" {
        + arn         = (known after apply)
        + create_date = (known after apply)
        + id          = (known after apply)
        + name        = "ec2_profile"
        + path        = "/"
        + role        = "ec2_role"
        + tags_all    = (known after apply)
        + unique_id   = (known after apply)
        }

    # aws_iam_role.ec2_role will be created
    + resource "aws_iam_role" "ec2_role" {
        + arn                   = (known after apply)
        + assume_role_policy    = jsonencode(
                {
                + Statement = [
                    + {
                        + Action    = "sts:AssumeRole"
                        + Effect    = "Allow"
                        + Principal = {
                            + Service = "ec2.amazonaws.com"
                            }
                        },
                    ]
                + Version   = "2012-10-17"
                }
            )
        + create_date           = (known after apply)
        + force_detach_policies = false
        + id                    = (known after apply)
        + managed_policy_arns   = (known after apply)
        + max_session_duration  = 3600
        + name                  = "ec2_role"
        + path                  = "/"
        + tags_all              = (known after apply)
        + unique_id             = (known after apply)

        + inline_policy {
            + name   = (known after apply)
            + policy = (known after apply)
            }
        }

    # aws_iam_role_policy.ec2_policy will be created
    + resource "aws_iam_role_policy" "ec2_policy" {
        + id     = (known after apply)
        + name   = "ec2_policy"
        + policy = jsonencode(
                {
                + Statement = [
                    + {
                        + Action   = [
                            + "s3:ListStorageLensConfigurations",
                            + "s3:ListAllMyBuckets",
                            + "s3:ListJobs",
                            + "ec2:*",
                            ]
                        + Effect   = "Allow"
                        + Resource = "*"
                        + Sid      = "Stmt202102171510"
                        },
                    + {
                        + Action   = [
                            + "s3:PutObject",
                            + "s3:GetObject",
                            + "s3:ListBucketMultipartUploads",
                            + "s3:ListBucketVersions",
                            + "s3:ListBucket",
                            + "s3:ListMultipartUploadParts",
                            ]
                        + Effect   = "Allow"
                        + Resource = [
                            + "arn:aws:s3:::task6-http/*",
                            + "arn:aws:s3:::task6-http/*/*",
                            ]
                        + Sid      = "Stmt202102171530"
                        },
                    ]
                + Version   = "2012-10-17"
                }
            )
        + role   = (known after apply)
        }

    # aws_instance.compute_nodes[0] will be created
    + resource "aws_instance" "compute_nodes" {
        + ami                                  = "ami-0ed05376b59b90e46"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + iam_instance_profile                 = "ec2_profile"
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t2.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "main"
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "my-compute-node-0"
            }
        + tags_all                             = {
            + "Name" = "my-compute-node-0"
            }
        + tenancy                              = (known after apply)
        + user_data                            = "c0b5ab9681e8c37c26ebdf4d3e065a82860b7f64"
        + vpc_security_group_ids               = (known after apply)

        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)

            + capacity_reservation_target {
                + capacity_reservation_id = (known after apply)
                }
            }

        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
            }

        + enclave_options {
            + enabled = (known after apply)
            }

        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
            }

        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            }

        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_interface_id  = (known after apply)
            }

        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
            }
        }

    # aws_instance.compute_nodes[1] will be created
    + resource "aws_instance" "compute_nodes" {
        + ami                                  = "ami-0ed05376b59b90e46"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
        + availability_zone                    = (known after apply)
        + cpu_core_count                       = (known after apply)
        + cpu_threads_per_core                 = (known after apply)
        + get_password_data                    = false
        + host_id                              = (known after apply)
        + iam_instance_profile                 = "ec2_profile"
        + id                                   = (known after apply)
        + instance_initiated_shutdown_behavior = (known after apply)
        + instance_state                       = (known after apply)
        + instance_type                        = "t2.micro"
        + ipv6_address_count                   = (known after apply)
        + ipv6_addresses                       = (known after apply)
        + key_name                             = "main"
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        + primary_network_interface_id         = (known after apply)
        + private_dns                          = (known after apply)
        + private_ip                           = (known after apply)
        + public_dns                           = (known after apply)
        + public_ip                            = (known after apply)
        + secondary_private_ips                = (known after apply)
        + security_groups                      = (known after apply)
        + source_dest_check                    = true
        + subnet_id                            = (known after apply)
        + tags                                 = {
            + "Name" = "my-compute-node-1"
            }
        + tags_all                             = {
            + "Name" = "my-compute-node-1"
            }
        + tenancy                              = (known after apply)
        + user_data                            = "c0b5ab9681e8c37c26ebdf4d3e065a82860b7f64"
        + vpc_security_group_ids               = (known after apply)

        + capacity_reservation_specification {
            + capacity_reservation_preference = (known after apply)

            + capacity_reservation_target {
                + capacity_reservation_id = (known after apply)
                }
            }

        + ebs_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + snapshot_id           = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
            }

        + enclave_options {
            + enabled = (known after apply)
            }

        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
            }

        + metadata_options {
            + http_endpoint               = (known after apply)
            + http_put_response_hop_limit = (known after apply)
            + http_tokens                 = (known after apply)
            }

        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_interface_id  = (known after apply)
            }

        + root_block_device {
            + delete_on_termination = (known after apply)
            + device_name           = (known after apply)
            + encrypted             = (known after apply)
            + iops                  = (known after apply)
            + kms_key_id            = (known after apply)
            + tags                  = (known after apply)
            + throughput            = (known after apply)
            + volume_id             = (known after apply)
            + volume_size           = (known after apply)
            + volume_type           = (known after apply)
            }
        }

    # aws_key_pair.main will be created
    + resource "aws_key_pair" "main" {
        + arn         = (known after apply)
        + fingerprint = (known after apply)
        + id          = (known after apply)
        + key_name    = "main"
        + key_pair_id = (known after apply)
        + public_key  = (known after apply)
        + tags_all    = (known after apply)
        }

    # aws_lb.alb will be created
    + resource "aws_lb" "alb" {
        + arn                        = (known after apply)
        + arn_suffix                 = (known after apply)
        + dns_name                   = (known after apply)
        + drop_invalid_header_fields = false
        + enable_deletion_protection = false
        + enable_http2               = true
        + id                         = (known after apply)
        + idle_timeout               = 60
        + internal                   = false
        + ip_address_type            = (known after apply)
        + load_balancer_type         = "application"
        + name                       = "my-alb"
        + security_groups            = (known after apply)
        + subnets                    = (known after apply)
        + tags_all                   = (known after apply)
        + vpc_id                     = (known after apply)
        + zone_id                    = (known after apply)

        + subnet_mapping {
            + allocation_id        = (known after apply)
            + ipv6_address         = (known after apply)
            + outpost_id           = (known after apply)
            + private_ipv4_address = (known after apply)
            + subnet_id            = (known after apply)
            }
        }

    # aws_lb_listener.alb_listener will be created
    + resource "aws_lb_listener" "alb_listener" {
        + arn               = (known after apply)
        + id                = (known after apply)
        + load_balancer_arn = (known after apply)
        + port              = 80
        + protocol          = "HTTP"
        + ssl_policy        = (known after apply)
        + tags_all          = (known after apply)

        + default_action {
            + order            = (known after apply)
            + target_group_arn = (known after apply)
            + type             = "forward"
            }
        }

    # aws_lb_target_group.alb_tg will be created
    + resource "aws_lb_target_group" "alb_tg" {
        + arn                                = (known after apply)
        + arn_suffix                         = (known after apply)
        + deregistration_delay               = 300
        + id                                 = (known after apply)
        + lambda_multi_value_headers_enabled = false
        + load_balancing_algorithm_type      = (known after apply)
        + name                               = "my-target-group"
        + port                               = 80
        + preserve_client_ip                 = (known after apply)
        + protocol                           = "HTTP"
        + protocol_version                   = (known after apply)
        + proxy_protocol_v2                  = false
        + slow_start                         = 0
        + tags_all                           = (known after apply)
        + target_type                        = "instance"
        + vpc_id                             = (known after apply)

        + health_check {
            + enabled             = (known after apply)
            + healthy_threshold   = (known after apply)
            + interval            = (known after apply)
            + matcher             = (known after apply)
            + path                = (known after apply)
            + port                = (known after apply)
            + protocol            = (known after apply)
            + timeout             = (known after apply)
            + unhealthy_threshold = (known after apply)
            }

        + stickiness {
            + cookie_duration = (known after apply)
            + cookie_name     = (known after apply)
            + enabled         = (known after apply)
            + type            = (known after apply)
            }
        }

    # aws_lb_target_group_attachment.target_registration[0] will be created
    + resource "aws_lb_target_group_attachment" "target_registration" {
        + id               = (known after apply)
        + port             = 80
        + target_group_arn = (known after apply)
        + target_id        = (known after apply)
        }

    # aws_lb_target_group_attachment.target_registration[1] will be created
    + resource "aws_lb_target_group_attachment" "target_registration" {
        + id               = (known after apply)
        + port             = 80
        + target_group_arn = (known after apply)
        + target_id        = (known after apply)
        }

    # aws_s3_bucket.task6_http will be created
    + resource "aws_s3_bucket" "task6_http" {
        + acceleration_status         = (known after apply)
        + acl                         = "private"
        + arn                         = (known after apply)
        + bucket                      = "task6-http"
        + bucket_domain_name          = (known after apply)
        + bucket_regional_domain_name = (known after apply)
        + force_destroy               = true
        + hosted_zone_id              = (known after apply)
        + id                          = (known after apply)
        + region                      = (known after apply)
        + request_payer               = (known after apply)
        + tags                        = {
            + "Name" = "My task6 bucket web"
            }
        + tags_all                    = {
            + "Name" = "My task6 bucket web"
            }
        + website_domain              = (known after apply)
        + website_endpoint            = (known after apply)

        + versioning {
            + enabled    = (known after apply)
            + mfa_delete = (known after apply)
            }
        }

    # aws_s3_bucket_object.file_upload will be created
    + resource "aws_s3_bucket_object" "file_upload" {
        + acl                    = "private"
        + bucket                 = (known after apply)
        + bucket_key_enabled     = (known after apply)
        + content_type           = "text/html"
        + etag                   = "e72b88c45ce2815a5bd2f84fb84fc526"
        + force_destroy          = false
        + id                     = (known after apply)
        + key                    = "index.html"
        + kms_key_id             = (known after apply)
        + server_side_encryption = (known after apply)
        + source                 = "scripts/index.html"
        + storage_class          = (known after apply)
        + tags_all               = (known after apply)
        + version_id             = (known after apply)
        }

    # aws_security_group.alb_sg will be created
    + resource "aws_security_group" "alb_sg" {
        + arn                    = (known after apply)
        + description            = "Managed by Terraform"
        + egress                 = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                    ]
                + description      = ""
                + from_port        = 0
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "-1"
                + security_groups  = []
                + self             = false
                + to_port          = 0
                },
            ]
        + id                     = (known after apply)
        + ingress                = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                    ]
                + description      = "Http"
                + from_port        = 80
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 80
                },
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                    ]
                + description      = "https for nginx"
                + from_port        = 443
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 443
                },
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                    ]
                + description      = "ping"
                + from_port        = 0
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "icmp"
                + security_groups  = []
                + self             = false
                + to_port          = 0
                },
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                    ]
                + description      = "ssh"
                + from_port        = 22
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 22
                },
            ]
        + name                   = "my-alb-security-grp"
        + name_prefix            = (known after apply)
        + owner_id               = (known after apply)
        + revoke_rules_on_delete = false
        + tags_all               = (known after apply)
        + vpc_id                 = (known after apply)
        }

    # local_file.ec2_private_key will be created
    + resource "local_file" "ec2_private_key" {
        + content              = (sensitive)
        + directory_permission = "0777"
        + file_permission      = "0777"
        + filename             = "./ec2_private_key.pem"
        + id                   = (known after apply)
        }

    # tls_private_key.main will be created
    + resource "tls_private_key" "main" {
        + algorithm                  = "RSA"
        + ecdsa_curve                = "P224"
        + id                         = (known after apply)
        + private_key_pem            = (sensitive value)
        + public_key_fingerprint_md5 = (known after apply)
        + public_key_openssh         = (known after apply)
        + public_key_pem             = (known after apply)
        + rsa_bits                   = 4096
        }

    # module.vpc.aws_internet_gateway.this[0] will be created
    + resource "aws_internet_gateway" "this" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + tags     = {
            + "Name" = "my-vpc"
            }
        + tags_all = {
            + "Name" = "my-vpc"
            }
        + vpc_id   = (known after apply)
        }

    # module.vpc.aws_route.public_internet_gateway[0] will be created
    + resource "aws_route" "public_internet_gateway" {
        + destination_cidr_block = "0.0.0.0/0"
        + gateway_id             = (known after apply)
        + id                     = (known after apply)
        + instance_id            = (known after apply)
        + instance_owner_id      = (known after apply)
        + network_interface_id   = (known after apply)
        + origin                 = (known after apply)
        + route_table_id         = (known after apply)
        + state                  = (known after apply)

        + timeouts {
            + create = "5m"
            }
        }

    # module.vpc.aws_route_table.public[0] will be created
    + resource "aws_route_table" "public" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + route            = (known after apply)
        + tags             = {
            + "Name" = "my-vpc-public"
            }
        + tags_all         = {
            + "Name" = "my-vpc-public"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[0] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[1] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_subnet.public[0] will be created
    + resource "aws_subnet" "public" {
        + arn                             = (known after apply)
        + assign_ipv6_address_on_creation = false
        + availability_zone               = "us-west-1b"
        + availability_zone_id            = (known after apply)
        + cidr_block                      = "10.0.101.0/24"
        + id                              = (known after apply)
        + ipv6_cidr_block_association_id  = (known after apply)
        + map_public_ip_on_launch         = true
        + owner_id                        = (known after apply)
        + tags                            = {
            + "Name" = "my-vpc-public-us-west-1b"
            }
        + tags_all                        = {
            + "Name" = "my-vpc-public-us-west-1b"
            }
        + vpc_id                          = (known after apply)
        }

    # module.vpc.aws_subnet.public[1] will be created
    + resource "aws_subnet" "public" {
        + arn                             = (known after apply)
        + assign_ipv6_address_on_creation = false
        + availability_zone               = "us-west-1c"
        + availability_zone_id            = (known after apply)
        + cidr_block                      = "10.0.102.0/24"
        + id                              = (known after apply)
        + ipv6_cidr_block_association_id  = (known after apply)
        + map_public_ip_on_launch         = true
        + owner_id                        = (known after apply)
        + tags                            = {
            + "Name" = "my-vpc-public-us-west-1c"
            }
        + tags_all                        = {
            + "Name" = "my-vpc-public-us-west-1c"
            }
        + vpc_id                          = (known after apply)
        }

    # module.vpc.aws_vpc.this[0] will be created
    + resource "aws_vpc" "this" {
        + arn                              = (known after apply)
        + assign_generated_ipv6_cidr_block = false
        + cidr_block                       = "10.0.0.0/16"
        + default_network_acl_id           = (known after apply)
        + default_route_table_id           = (known after apply)
        + default_security_group_id        = (known after apply)
        + dhcp_options_id                  = (known after apply)
        + enable_classiclink               = (known after apply)
        + enable_classiclink_dns_support   = (known after apply)
        + enable_dns_hostnames             = false
        + enable_dns_support               = true
        + id                               = (known after apply)
        + instance_tenancy                 = "default"
        + ipv6_association_id              = (known after apply)
        + ipv6_cidr_block                  = (known after apply)
        + main_route_table_id              = (known after apply)
        + owner_id                         = (known after apply)
        + tags                             = {
            + "Name" = "my-vpc"
            }
        + tags_all                         = {
            + "Name" = "my-vpc"
            }
        }

    Plan: 24 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
    + lb_dns = (known after apply)

</details>
