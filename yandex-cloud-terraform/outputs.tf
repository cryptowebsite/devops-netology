output "vm_privat_ip" {
  value = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "subnet_id" {
  value = yandex_vpc_subnet.vm_subnet.id
}
