locals {
  # Common tags to be assigned to all resources
  common_name                 = join("-", [var.business_unit, var.environment])
  bastion_name                = var.optional_identifier != "" ? join("-", [local.common_name, "bastion-host", var.optional_identifier]) : join("-", [local.common_name, "bastion-host"])
  bastion_key_pair_name       = var.optional_identifier != "" ? join("-", [local.common_name, "bastion-key", var.optional_identifier]) : join("-", [local.common_name, "bastion-key"])
  bastion_security_group_name = var.optional_identifier != "" ? join("-", [local.common_name, "bastion-security-group", var.optional_identifier]) : join("-", [local.common_name, "bastion-security-group"])
  bastion_eip                 = var.optional_identifier != "" ? join("-", [local.common_name, "bastion-eip", var.optional_identifier]) : join("-", [local.common_name, "bastion-eip"])

  ingress_rules = var.sg_ingress
  common_tags = {
    Name        = local.common_name
    Environment = var.environment
    Module      = "Bastion"
    Terraform   = "true"
    CreatedBy   = var.author
    PartOfInfra = "true"
  }
}


module "bastion_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"
  name    = local.bastion_name

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = resource.aws_key_pair.bastion_key.key_name
  monitoring                  = var.monitoring
  vpc_security_group_ids      = ["${aws_security_group.sg_bastion_server.id}"]
  subnet_id                   = var.pub_subnet_id
  availability_zone           = var.az[0]
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("init.sh")

  tags = merge(local.common_tags, {
    Name = "${local.bastion_name}"
  })

}
resource "tls_private_key" "bastion_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = local.bastion_key_pair_name
  public_key = tls_private_key.bastion_private_key.public_key_openssh
  # To Generate and save private key () in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.bastion_private_key.private_key_pem}' > '${local.bastion_key_pair_name}.pem'
      chmod 400 '${local.bastion_key_pair_name}.pem'
    EOT
  }
  tags = merge(local.common_tags, {
    Name = "${local.bastion_key_pair_name}"
  })
}

resource "aws_eip" "bastion_eip" {
  domain   = var.eip_domain
  instance = module.bastion_instance.id
  tags = merge(local.common_tags, {
    Name = local.bastion_eip
  })
}

resource "aws_security_group" "sg_bastion_server" {
  name        = local.bastion_security_group_name
  description = local.bastion_security_group_name
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description     = ingress.value.description
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      cidr_blocks     = lookup(ingress.value, "cidr", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
