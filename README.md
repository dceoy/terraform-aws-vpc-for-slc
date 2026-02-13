# terraform-aws-vpc-for-slc

Terraform modules of Amazon VPC for serverless computing

[![CI](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-aws-vpc-for-slc/actions/workflows/ci.yml)

## Installation

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-aws-vpc-for-slc.git
    $ cd terraform-aws-vpc-for-slc
    ```

2.  Install [AWS CLI](https://aws.amazon.com/cli/) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Install [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/).

4.  Initialize Terraform working directories.

    ```sh
    $ terragrunt run --all --working-dir='envs/dev/' -- init -upgrade -reconfigure
    ```

5.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terragrunt run --all --working-dir='envs/dev/' -- plan
    ```

6.  Creates or updates infrastructure.

    ```sh
    $ terragrunt run --all --working-dir='envs/dev/' -- apply --non-interactive
    ```

7.  Retrieve the session document name, the EC2 instance ID, and the private key PEM name.

    ```sh
    $ terragrunt output --working-dir='envs/dev/ssm/' -raw ssm_session_document_name
    $ terragrunt output --working-dir='envs/dev/ec2/' -raw ec2_instance_id_ssm_parameter_name
    $ terragrunt output --working-dir='envs/dev/ec2/' -raw ec2_private_key_pem_ssm_parameter_name
    ```

## Usage

1.  Use the EC2 instance. (`create_ec2_instance = true`)

    Option 1: Start a session using AWS CLI.
    (Replace `slc-dev-ssm-session-document` and `/slc/dev/ec2-instance-id/slc-dev-ec2-instance`.)

    ```sh
    $ aws ssm start-session \
        --document-name "slc-dev-ssm-session-document" \
        --target "$( \
          aws ssm get-parameter \
            --name "/slc/dev/ec2-instance-id/slc-dev-ec2-instance" \
            --query Parameter.Value \
            --output text \
        )"
    ```

    Option 2: Start a session using SSH.
    (Replace `/slc/dev/ec2-private-key-pem/slc-dev-ec2-key-pair`, `slc-dev-ssm-session-document`, and `/slc/dev/ec2-public-ip/slc-dev-ec2-instance`.)

    ```sh
    $ aws ssm get-parameter \
        --name "/slc/dev/ec2-private-key-pem/slc-dev-ec2-key-pair" \
        --query Parameter.Value \
        --output text \
        --with-decryption \
        > slc-dev-ec2-key-pair.pem
    $ chmod 600 slc-dev-ec2-key-pair.pem
    $ ssh \
        -o ProxyCommand="aws ssm start-session --target %h --document-name slc-dev-ssm-session-document --parameters 'portNumber=%p'" \
        -i slc-dev-ec2-key-pair.pem \
        "ec2-user@$( \
          aws ssm get-parameter \
            --name "/slc/dev/ec2-public-ip/slc-dev-ec2-instance" \
            --query Parameter.Value \
            --output text \
        )"
    ```

## Cleanup

```sh
$ terragrunt run --all --working-dir='envs/dev/' -- destroy --non-interactive
```
