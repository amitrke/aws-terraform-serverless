# aws-terraform-serverless

AWS Terraform APIGateway and Lambda example.

Prerequisite
- Terraform cli https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

terraform init

terraform apply

IAM User
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Lambda",
            "Effect": "Allow",
            "Action": [
                "lambda:*"
            ],
            "Resource": "arn:aws:lambda:*:975848467324:function:slsapp1-*"
        },
        {
            "Sid": "IAM",
            "Effect": "Allow",
            "Action": [
                "iam:*"
            ],
            "Resource": "arn:aws:iam::975848467324:role/slsapp1-*"
        },
        {
            "Sid": "S3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::slsapp1-*"
        }
    ]
}
```
