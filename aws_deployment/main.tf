data "aws_ami" "this" {
  most_recent      = true
  name_regex       = "^.?metaport.*?$"
  owners           = var.aws_ami_metaport_owners
}

data "aws_subnet" "this" {
  for_each                                  = { 
    for connector in var.aws_metaport_connectors : connector.aws_mp_connector_name => connector 
  }
  id                                        = each.value.aws_mp_connector_subnet_id
}

locals {
  otacs = {
    for otac in metanetworks_metaport_otac.this : local.metaports[otac.metaport_id].name => {
      rendered                =<<-EOF
Content-Type: multipart/mixed; boundary="MIMEBOUNDARY"
MIME-Version: 1.0

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/x-shellscript
Mime-Version: 1.0

#!/bin/bash
su mpadmin -c "metaport onboard ${otac.secret}"

--MIMEBOUNDARY--
      EOF
    }
  }
  metaports = {
    for connector in metanetworks_metaport.this : connector.id => connector
  }
}

resource "metanetworks_metaport" "this" {
    for_each                    = { for connector in var.aws_metaport_connectors : connector.aws_mp_connector_name => connector }
    name                        = each.key
    enabled                     = true
    description                 = each.value.aws_mp_connector_description
}


resource "metanetworks_metaport_otac" "this" {
    for_each                    = { for connector in metanetworks_metaport.this : connector.name => connector }
    metaport_id                 = each.value.id
    depends_on                  = [metanetworks_metaport.this]
}

resource "aws_security_group" "this" {
  for_each                                = {
    for sg in var.aws_metaport_security_groups : sg.aws_mp_sg_name => sg
  }
  name                                    = each.key
  description                             = each.value.aws_mp_sg_description
  vpc_id                                  = each.value.aws_mp_sg_vpc_id
  dynamic "egress" {
    for_each                              = each.value.aws_mp_sg_egress_rules
    content {
      description                           = egress.value.egress_rule_description
      from_port                             = egress.value.egress_rule_from_port
      to_port                               = egress.value.egress_rule_to_port
      protocol                              = egress.value.egress_rule_protocol
      cidr_blocks                           = egress.value.egress_rule_cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each                              = each.value.aws_mp_sg_ingress_rules
    content {
      description                           = ingress.value.ingress_rule_description
      from_port                             = ingress.value.ingress_rule_from_port
      to_port                               = ingress.value.ingress_rule_to_port
      protocol                              = ingress.value.ingress_rule_protocol
      cidr_blocks                           = ingress.value.ingress_rule_cidr_blocks
    }
  }
}

resource "aws_instance" "this" {
  for_each                                = {
    for connector in var.aws_metaport_connectors : connector.aws_mp_connector_name => connector
  }
  ami                                     = data.aws_ami.this.id
  availability_zone                       = data.aws_subnet.this[each.key].availability_zone
  instance_type                           = each.value.aws_mp_connector_instance_type
  vpc_security_group_ids                  = [ for s in each.value.aws_mp_connector_sgs : aws_security_group.this[s].id ]
  subnet_id                               = each.value.aws_mp_connector_subnet_id
  user_data                               = local.otacs[each.key].rendered
  key_name                                = each.value.aws_mp_connector_key_pair
  associate_public_ip_address             = each.value.aws_mp_connector_public_ip
  tags                                    = {
    Name                                  = each.key
    App                                   = "metaport"
    Project                               = "metanetworks"
  }
}

resource "aws_key_pair" "this" {
  for_each                                = { for keypair in var.aws_key_pairs : keypair.aws_key_name => keypair }
  key_name                                = each.key
  public_key                              = each.value.aws_key_public
}