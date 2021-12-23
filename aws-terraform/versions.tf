terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "netology-study"
    key    = "state/netology"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt= true
  }
}
