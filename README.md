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
    $ cp env/dev/example.tfbackend env/dev/aws.tfbackend
    $ cp env/dev/example.tfvars env/dev/dev.tfvars
    $ vi env/dev/aws.tfbackend
    $ vi env/dev/dev.tfvars
    ```

5.  Initialize a new Terraform working directory.

    ```sh
    $ terraform -chdir='envs/dev/' init -reconfigure -backend-config='./aws.tfbackend'
    ```

6.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terraform -chdir='envs/dev/' plan -var-file='./dev.tfvars'
    ```

7.  Creates or updates infrastructure.

    ```sh
    $ terraform -chdir='envs/dev/' apply -var-file='./dev.tfvars' -auto-approve
    ```

8.  Retrieve the private key of an EC2 instance and log in to it. (Optional)

    ```sh
    $ aws ssm get-parameter \
        --name "$(terraform -chdir='envs/dev/' output -raw ec2_private_key_name)" \
        --with-decryption \
        | jq -r .Parameter.Value \
        > slc-dev-ec2-key-pair.pem
    $ chmod 600 slc-dev-ec2-key-pair.pem
    $ ssh \
        -o ProxyCommand="aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        -i slc-dev-ec2-key-pair.pem \
        "ec2-user@$(terraform -chdir='envs/dev/' output -raw ec2_instance_id)"
    ```

Cleanup
-------

```sh
$ terraform -chdir='envs/dev/' apply -var-file='./dev.tfvars' -auto-approve -destroy
```
