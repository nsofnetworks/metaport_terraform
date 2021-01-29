variable "aws_region" {
    type    = string
}

variable "shared_credentials_file" {
  type = string
}

variable "profile" {
  type = string
}

variable "aws_ami_metaport_owners" {
    type    = list(string)
}

variable "aws_metaport_connectors" {
    type    = list(object({
        aws_mp_connector_name               = string
        aws_mp_connector_description        = string
        aws_mp_connector_instance_type      = string
        aws_mp_connector_sgs                = list(string) #security_group_names
        aws_mp_connector_subnet_id          = string
        aws_mp_connector_key_pair           = string
        aws_mp_connector_public_ip          = bool
    }))
}
variable "aws_metaport_security_groups" {
    type                                    = list(object({
        aws_mp_sg_name                      = string
        aws_mp_sg_description               = string
        aws_mp_sg_vpc_id                    = string # aws_vpc_id
        aws_mp_sg_egress_rules              = list(object({
            egress_rule_description         = string
            egress_rule_from_port           = number
            egress_rule_to_port             = number
            egress_rule_protocol            = string
            egress_rule_cidr_blocks         = list(string) # list_of_cidr_blocks
        }))
        aws_mp_sg_ingress_rules             = list(object({
            ingress_rule_description        = string
            ingress_rule_from_port          = number
            ingress_rule_to_port            = number
            ingress_rule_protocol           = string
            ingress_rule_cidr_blocks        = list(string) # list_of_cidr_blocks
        }))
    }))
}

variable "aws_key_pairs" {
    type                                    = list(object({
        aws_key_name                        = string
        aws_key_public                      = string
    }))
}
