terraform-aws-vpc-for-slc
=========================

Terraform module of VPC for serverless computing

[![Lint](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/lint.yml/badge.svg)](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/lint.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-aws-vpc-for-slc.git
    $ cd terraform-aws-vpc-for-slc
    ````

2.  Install [AWS CLI](https://aws.amazon.com/cli/) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Create a S3 bucket and a DynamoDB table for Terraform.

    ```sh
    $ aws cloudformation create-stack \
        --stack-name s3-and-dynamodb-for-terraform \
        --template-body file://s3-and-dynamodb-for-terraform.cfn.yml
    ```

4.  Create configuration files.

    ```sh
    $ vi dev.tfbackend.json
    $ vi dev.tfvars.json
    ```

5.  Initialize a new Terraform working directory.

    ```sh
    $ terraform -chdir='envs/dev/' init -reconfigure -backend-config='../../dev.tfbackend.json'
    ```

6.  Generates a speculative execution plan.

    ```sh
    $ terraform -chdir='envs/dev/' plan -var-file='../../dev.tfvars.json'
    ```

Cleanup
-------

```sh
$ terraform -chdir='envs/dev/' plan -var-file='../../dev.tfvars.json' -destroy
```
