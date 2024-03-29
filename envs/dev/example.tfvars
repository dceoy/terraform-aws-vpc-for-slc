region                         = "us-east-1"
profile                        = "default"
system_name                    = "slc"
env_type                       = "dev"
vpc_cidr_block                 = "10.0.0.0/16"
enable_vpc_flow_log            = true
private_subnet_count           = 3
public_subnet_count            = 3
subnet_newbits                 = 8
create_nat_gateways            = true
create_vpc_interface_endpoints = true
create_ec2_instance            = true
idle_session_timeout           = 60
image_id                       = "ami-06a2375cfef712d1b"
instance_type                  = "t4g.small"
ebs_volume_size                = 32
use_ssh                        = false
