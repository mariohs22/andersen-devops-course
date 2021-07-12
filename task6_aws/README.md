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
    Note: Objects have changed outside of Terraform
    Terraform detected the following changes made outside of Terraform since the last "terraform apply":

    # aws_instance.compute_nodes[0] has been changed
    ~ resource "aws_instance" "compute_nodes" {
            id                                   = "i-070c5701f20a9f2bf"
        ~ security_groups                      = [
            - "sg-0b2246979a4c34ec0",
            ]
            tags                                 = {
                "Name" = "my-compute-node-0"
            }
            # (29 unchanged attributes hidden)





            # (5 unchanged blocks hidden)
        }
    # aws_instance.compute_nodes[1] has been changed
    ~ resource "aws_instance" "compute_nodes" {
            id                                   = "i-0468099a6c1d58e9b"
        ~ security_groups                      = [
            - "sg-0b2246979a4c34ec0",
            ]
            tags                                 = {
                "Name" = "my-compute-node-1"
            }
            # (29 unchanged attributes hidden)





            # (5 unchanged blocks hidden)
        }
    # local_file.ec2_private_key has been deleted
    - resource "local_file" "ec2_private_key" {
        - content              = (sensitive) -> null
        - directory_permission = "0777" -> null
        - file_permission      = "0777" -> null
        - filename             = "./ec2_private_key.pem" -> null
        - id                   = "ebd8f10825bc396947ba20af161a5daa062aeeb2" -> null
        }

    Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create
    ~ update in-place
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # aws_instance.compute_nodes[0] must be replaced
    -/+ resource "aws_instance" "compute_nodes" {
        ~ ami                                  = "ami-02f24ad9a1d24a799" -> "ami-0ed05376b59b90e46" # forces replacement
        ~ arn                                  = "arn:aws:ec2:us-west-1:398332759214:instance/i-070c5701f20a9f2bf" -> (known after apply)
        ~ associate_public_ip_address          = true -> (known after apply)
        ~ availability_zone                    = "us-west-1b" -> (known after apply)
        ~ cpu_core_count                       = 1 -> (known after apply)
        ~ cpu_threads_per_core                 = 1 -> (known after apply)
        - disable_api_termination              = false -> null
        - ebs_optimized                        = false -> null
        - hibernation                          = false -> null
        + host_id                              = (known after apply)
        ~ id                                   = "i-070c5701f20a9f2bf" -> (known after apply)
        ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
        ~ instance_state                       = "running" -> (known after apply)
        ~ ipv6_address_count                   = 0 -> (known after apply)
        ~ ipv6_addresses                       = [] -> (known after apply)
        - monitoring                           = false -> null
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        ~ primary_network_interface_id         = "eni-0e3472fad3a13bb05" -> (known after apply)
        ~ private_dns                          = "ip-10-0-101-245.us-west-1.compute.internal" -> (known after apply)
        ~ private_ip                           = "10.0.101.245" -> (known after apply)
        + public_dns                           = (known after apply)
        ~ public_ip                            = "54.241.137.137" -> (known after apply)
        ~ secondary_private_ips                = [] -> (known after apply)
        ~ security_groups                      = [ # forces replacement
            + "sg-0b2246979a4c34ec0",
            ]
            tags                                 = {
                "Name" = "my-compute-node-0"
            }
        ~ tenancy                              = "default" -> (known after apply)
        ~ user_data                            = "f211d78eb140c49ba7b42cd4ad3474db26cb7426" -> "c0b5ab9681e8c37c26ebdf4d3e065a82860b7f64" # forces replacement
        ~ vpc_security_group_ids               = [
            - "sg-0b2246979a4c34ec0",
            ] -> (known after apply)
            # (7 unchanged attributes hidden)

        ~ capacity_reservation_specification {
            ~ capacity_reservation_preference = "open" -> (known after apply)

            + capacity_reservation_target {
                + capacity_reservation_id = (known after apply)
                }
            }

        - credit_specification {
            - cpu_credits = "standard" -> null
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

        ~ enclave_options {
            ~ enabled = false -> (known after apply)
            }

        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
            }

        ~ metadata_options {
            ~ http_endpoint               = "enabled" -> (known after apply)
            ~ http_put_response_hop_limit = 1 -> (known after apply)
            ~ http_tokens                 = "optional" -> (known after apply)
            }

        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_interface_id  = (known after apply)
            }

        ~ root_block_device {
            ~ delete_on_termination = true -> (known after apply)
            ~ device_name           = "/dev/xvda" -> (known after apply)
            ~ encrypted             = false -> (known after apply)
            ~ iops                  = 100 -> (known after apply)
            + kms_key_id            = (known after apply)
            ~ tags                  = {} -> (known after apply)
            ~ throughput            = 0 -> (known after apply)
            ~ volume_id             = "vol-0c97f1ab2deccdae0" -> (known after apply)
            ~ volume_size           = 8 -> (known after apply)
            ~ volume_type           = "gp2" -> (known after apply)
            }
        }

    # aws_instance.compute_nodes[1] must be replaced
    -/+ resource "aws_instance" "compute_nodes" {
        ~ ami                                  = "ami-02f24ad9a1d24a799" -> "ami-0ed05376b59b90e46" # forces replacement
        ~ arn                                  = "arn:aws:ec2:us-west-1:398332759214:instance/i-0468099a6c1d58e9b" -> (known after apply)
        ~ associate_public_ip_address          = true -> (known after apply)
        ~ availability_zone                    = "us-west-1c" -> (known after apply)
        ~ cpu_core_count                       = 1 -> (known after apply)
        ~ cpu_threads_per_core                 = 1 -> (known after apply)
        - disable_api_termination              = false -> null
        - ebs_optimized                        = false -> null
        - hibernation                          = false -> null
        + host_id                              = (known after apply)
        ~ id                                   = "i-0468099a6c1d58e9b" -> (known after apply)
        ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
        ~ instance_state                       = "running" -> (known after apply)
        ~ ipv6_address_count                   = 0 -> (known after apply)
        ~ ipv6_addresses                       = [] -> (known after apply)
        - monitoring                           = false -> null
        + outpost_arn                          = (known after apply)
        + password_data                        = (known after apply)
        + placement_group                      = (known after apply)
        ~ primary_network_interface_id         = "eni-099d5c2dee722c040" -> (known after apply)
        ~ private_dns                          = "ip-10-0-102-127.us-west-1.compute.internal" -> (known after apply)
        ~ private_ip                           = "10.0.102.127" -> (known after apply)
        + public_dns                           = (known after apply)
        ~ public_ip                            = "54.215.205.68" -> (known after apply)
        ~ secondary_private_ips                = [] -> (known after apply)
        ~ security_groups                      = [ # forces replacement
            + "sg-0b2246979a4c34ec0",
            ]
            tags                                 = {
                "Name" = "my-compute-node-1"
            }
        ~ tenancy                              = "default" -> (known after apply)
        ~ user_data                            = "f211d78eb140c49ba7b42cd4ad3474db26cb7426" -> "c0b5ab9681e8c37c26ebdf4d3e065a82860b7f64" # forces replacement
        ~ vpc_security_group_ids               = [
            - "sg-0b2246979a4c34ec0",
            ] -> (known after apply)
            # (7 unchanged attributes hidden)

        ~ capacity_reservation_specification {
            ~ capacity_reservation_preference = "open" -> (known after apply)

            + capacity_reservation_target {
                + capacity_reservation_id = (known after apply)
                }
            }

        - credit_specification {
            - cpu_credits = "standard" -> null
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

        ~ enclave_options {
            ~ enabled = false -> (known after apply)
            }

        + ephemeral_block_device {
            + device_name  = (known after apply)
            + no_device    = (known after apply)
            + virtual_name = (known after apply)
            }

        ~ metadata_options {
            ~ http_endpoint               = "enabled" -> (known after apply)
            ~ http_put_response_hop_limit = 1 -> (known after apply)
            ~ http_tokens                 = "optional" -> (known after apply)
            }

        + network_interface {
            + delete_on_termination = (known after apply)
            + device_index          = (known after apply)
            + network_interface_id  = (known after apply)
            }

        ~ root_block_device {
            ~ delete_on_termination = true -> (known after apply)
            ~ device_name           = "/dev/xvda" -> (known after apply)
            ~ encrypted             = false -> (known after apply)
            ~ iops                  = 100 -> (known after apply)
            + kms_key_id            = (known after apply)
            ~ tags                  = {} -> (known after apply)
            ~ throughput            = 0 -> (known after apply)
            ~ volume_id             = "vol-01459f2a9841f1866" -> (known after apply)
            ~ volume_size           = 8 -> (known after apply)
            ~ volume_type           = "gp2" -> (known after apply)
            }
        }

    # aws_lb_target_group_attachment.target_registration[0] must be replaced
    -/+ resource "aws_lb_target_group_attachment" "target_registration" {
        ~ id               = "arn:aws:elasticloadbalancing:us-west-1:398332759214:targetgroup/my-target-group/9e5c939358faeefb-20210705160850200800000002" -> (known after apply)
        ~ target_id        = "i-070c5701f20a9f2bf" -> (known after apply) # forces replacement
            # (2 unchanged attributes hidden)
        }

    # aws_lb_target_group_attachment.target_registration[1] must be replaced
    -/+ resource "aws_lb_target_group_attachment" "target_registration" {
        ~ id               = "arn:aws:elasticloadbalancing:us-west-1:398332759214:targetgroup/my-target-group/9e5c939358faeefb-20210705160850113100000001" -> (known after apply)
        ~ target_id        = "i-0468099a6c1d58e9b" -> (known after apply) # forces replacement
            # (2 unchanged attributes hidden)
        }

    # aws_s3_bucket_object.file_upload will be updated in-place
    ~ resource "aws_s3_bucket_object" "file_upload" {
        ~ etag               = "870c2d9c40fa2581b74d99f7103e427f" -> "e72b88c45ce2815a5bd2f84fb84fc526"
            id                 = "index.html"
            tags               = {}
        + version_id         = (known after apply)
            # (10 unchanged attributes hidden)
        }

    # local_file.ec2_private_key will be created
    + resource "local_file" "ec2_private_key" {
        + content              = (sensitive)
        + directory_permission = "0777"
        + file_permission      = "0777"
        + filename             = "./ec2_private_key.pem"
        + id                   = (known after apply)
        }

</details>
