terraform {
  backend "s3" {
    bucket         = "demo-non-prod-terraform-states"
    key            = "dev/vpc-demo.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
  }
}

/*
aws s3api create-bucket \
        --bucket demo-non-prod-terraform-states \
        --region eu-central-1
aws dynamodb create-table \
        --region eu-central-1 \
        --table-name terraform-state-lock \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST
*/
