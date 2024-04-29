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

3.  Install [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/).

4.  Initialize Terraform working directories.

    ```sh
    $ terragrunt run-all init --terragrunt-working-dir='envs/dev/' -upgrade -reconfigure
    ```

5.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terragrunt run-all plan --terragrunt-working-dir='envs/dev/'
    ```

6.  Creates or updates infrastructure.

    ```sh
    $ terragrunt run-all apply --terragrunt-working-dir='envs/dev/' --terragrunt-non-interactive
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
$ terragrunt run-all apply --terragrunt-working-dir='envs/dev/' --terragrunt-non-interactive -destroy
```
