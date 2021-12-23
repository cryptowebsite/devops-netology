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

resource "aws_instance" "vm2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.vm_instance_type[terraform.workspace]
  cpu_core_count = local.vm_cores[terraform.workspace]
  ebs_optimized = true
  hibernation = true
  monitoring = true
  cpu_threads_per_core = 2
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "stop"

  for_each = toset( local.vm_names[terraform.workspace] )

  tags = {
    Name = each.key
  }

  metadata_options {
    http_endpoint = "enabled"
    http_put_response_hop_limit = 32
    http_tokens = "required"
  }

  lifecycle {
    create_before_destroy = true
  }

  credit_specification {
    cpu_credits = "standard"
  }
}
