provider "aws" {
  region = "ap-southeast-1"
}

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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  cpu_core_count = 1
  ebs_optimized = true
  hibernation = true
  monitoring = true
  cpu_threads_per_core = 2
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "stop"

  tags = {
    Name = "Netology_VM"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_put_response_hop_limit = 32
    http_tokens = "required"
  }

  network_interface {
    network_interface_id = aws_network_interface.vm_interface.id
    device_index         = 0
  }


  lifecycle {
    create_before_destroy = true
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_vpc" "vm_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "vm_network"
  }
}

resource "aws_subnet" "vm_subnet" {
  vpc_id            = aws_vpc.vm_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "vm-subnet"
  }
}

resource "aws_network_interface" "vm_interface" {
  subnet_id   = aws_subnet.vm_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "vm_ip" {
  instance = aws_instance.vm.id
}
