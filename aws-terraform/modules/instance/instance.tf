variable image { default =  "ubuntu" }
variable name { default = ""}
variable cores { default = 2 }
variable description { default =  "instance from terraform" }
variable instance_type { default =  "t2.micro" }
variable instance_count { default =  1 }

resource "aws_instance" "instance" {
  ami           = var.image
  instance_type = var.instance_type
  cpu_core_count = var.cores
  count = var.instance_count
  ebs_optimized = true
  hibernation = true
  monitoring = true
  cpu_threads_per_core = 2
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "stop"

  tags = {
    Name = var.name
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