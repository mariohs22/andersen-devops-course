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
