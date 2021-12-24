data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  vm_cores = {
    stage = 2
    prod = 2
  }
  vm_instance_type = {
    stage = "t2.micro"
    prod = "t2.large"
  }
  vm_instance_count = {
    stage = 1
    prod = 2
  }
  vm_names = {
    stage = ["vm1-stage"]
    prod = ["vm1-prod", "vm2-prod"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = terraform.workspace
  cidr = "10.0.0.0/16"

  azs             = [var.aws_region]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "vm1" {
  source = "./modules/instance"
  instance_count = local.vm_instance_count[terraform.workspace]
  instance_type = local.vm_instance_type[terraform.workspace]
  image         = data.aws_ami.ubuntu.id
  name          = "vm1"
  description   = "VM1"
  cores         = local.vm_cores[terraform.workspace]
  depends_on = [
    module.vpc
  ]
}

module "vm2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  for_each = toset(local.vm_names[terraform.workspace])
  name = "instance-${each.key}"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.vm_instance_type[terraform.workspace]
  key_name               = "user1"
  monitoring             = true
}

