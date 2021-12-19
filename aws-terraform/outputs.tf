output "vm_public_ip" {
  value = aws_eip.vm_ip.public_ip
}

output "vm_privat_ip" {
  value = aws_eip.vm_ip.private_ip
}

output "subnet_id" {
  value = aws_vpc.vm_vpc.id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "current_region" {
  value = data.aws_region.current.name
}
