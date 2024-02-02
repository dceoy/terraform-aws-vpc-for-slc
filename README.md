terraform-aws-vpc-for-slc
=========================

Terraform modules of Amazon VPC for serverless computing

[![Lint and scan](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/lint-and-scan.yml/badge.svg)](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/lint-and-scan.yml)

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

Usage
-----

1.  Use the EC2 instance. (`create_ec2_instance = true`)

    Option 1:   Start a session and log session data using Amazon CloudWatch Logs. (`use_ssh = false`)

    ```sh
    $ aws ssm start-session \
        --document-name "$(terraform -chdir='envs/dev/' output -raw ssm_session_document_name)" \
        --target "$( \
          aws ssm get-parameter \
            --name "$(terraform -chdir='envs/dev/' output -raw ec2_instance_id_ssm_parameter_name)" \
            --query Parameter.Value \
            --output text \
        )"
    ```

    Option 2:   Start a session using SSH. (`use_ssh = true`)

    ```sh
    $ aws ssm get-parameter \
        --name "$(terraform -chdir='envs/dev/' output -raw ec2_private_key_pem_ssm_parameter_name)" \
        --query Parameter.Value \
        --output text \
        --with-decryption \
        > slc-dev-ec2-key-pair.pem
    $ chmod 600 slc-dev-ec2-key-pair.pem
    $ ssh \
        -o ProxyCommand="aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        -i slc-dev-ec2-key-pair.pem \
        "ec2-user@$( \
          aws ssm get-parameter \
            --name "$(terraform -chdir='envs/dev/' output -raw ec2_instance_id_ssm_parameter_name)" \
            --query Parameter.Value \
            --output text \
        )"
    ```

Cleanup
-------

```sh
$ terraform -chdir='envs/dev/' apply -var-file='./dev.tfvars' -auto-approve -destroy
```
