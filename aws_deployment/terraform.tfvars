aws_region                  = "<Provide the region where the MetaPort should be launched>"
aws_ami_metaport_owners      = ["802760723056"] #Meta's account used to share the AMI

shared_credentials_file = "$HOME/.aws/credentials"

profile = "<Provide your profile name>"

aws_metaport_connectors                     = [
    {
        aws_mp_connector_name               = "MetaPort-Terraform"
        aws_mp_connector_description        = "MetaPort Terraform"
        aws_mp_connector_instance_type      = "t3.small"
        aws_mp_connector_sgs                = ["allow_meta_out_deny_all"]
        aws_mp_connector_subnet_id          = "<provide the subnet id where the instance should be launched>" # Private 2b
        aws_mp_connector_key_pair           = "<Provide the keypair name>"
        aws_mp_connector_public_ip          = false
    }
]

aws_metaport_security_groups                = [
    {
        aws_mp_sg_name                      = "allow_meta_out_deny_all"
        aws_mp_sg_description               = "Allows only meta traffic out. Blocks all other out/in"
        aws_mp_sg_vpc_id                    = "<Provide the VPC Id where the Instance should be launched>"
        aws_mp_sg_ingress_rules             = [
            {
                ingress_rule_description    = "Allow SSH Management Inbound. TCP 22"
                ingress_rule_from_port      = 22
                ingress_rule_to_port        = 22
                ingress_rule_protocol       = "tcp"
                ingress_rule_cidr_blocks    = ["0.0.0.0/0"]
            },
            {
                ingress_rule_description    = "Allow metaport keep alive inbound. ICMP"
                ingress_rule_from_port      = -1
                ingress_rule_to_port        = -1
                ingress_rule_protocol       = "icmp"
                ingress_rule_cidr_blocks    = ["0.0.0.0/0"]
            }
        ]
        aws_mp_sg_egress_rules              = [
            {
                egress_rule_description    = "Allow metaport tunneling outbound. UDP 500"
                egress_rule_from_port      = 500
                egress_rule_to_port        = 500
                egress_rule_protocol       = "udp"
                egress_rule_cidr_blocks    = ["0.0.0.0/0"] # we will be locking this down post launch
            },
            {
                egress_rule_description    = "Allow metaport tunneling outbound. UDP 4500"
                egress_rule_from_port      = 4500
                egress_rule_to_port        = 4500
                egress_rule_protocol       = "udp"
                egress_rule_cidr_blocks    = ["0.0.0.0/0"] # we will be locking this down post launch
            },
            {
                egress_rule_description    = "Allow metaport tunneling outbound. TCP 443"
                egress_rule_from_port      = 443
                egress_rule_to_port        = 443
                egress_rule_protocol       = "tcp"
                egress_rule_cidr_blocks    = ["0.0.0.0/0"] # we will be locking this down post launch
            },
            {
                egress_rule_description    = "Allow metaport tunneling outbound. TCP 443"
                egress_rule_from_port      = 443
                egress_rule_to_port        = 443
                egress_rule_protocol       = "tcp"
                egress_rule_cidr_blocks    = ["0.0.0.0/0"] # we will be locking this down post launch
            },
            {
                egress_rule_description    = "Allow metaport keep alive outbound. ICMP"
                egress_rule_from_port      = -1
                egress_rule_to_port        = -1
                egress_rule_protocol       = "icmp"
                egress_rule_cidr_blocks    = ["0.0.0.0/0"] # we will be locking this down post launch
            }
        ]
    }
]

aws_key_pairs = [
    {
        aws_key_name                        = "<Provide your key pair name>"
        aws_key_public                      = "<Insert your public key>" # Insert Public Key
    }
]