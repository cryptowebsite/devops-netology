provider "yandex" {
  cloud_id  = "b1gsvg57220fl1f4agtc"
  folder_id = "b1g8n8d6tmplil5u4286"
  zone      = "ru-central1-a"
}

data "yandex_compute_image" "image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm" {
  name = "netology"
  platform_id = "standard-v1"
  hostname = "netology"
  description = "vm for netology"
  allow_stopping_for_update = true
  network_acceleration_type = "standard"

  resources {
    cores  = "2"
    memory = "2048"
    core_fraction = "100"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = "network-hdd"
      size = "20"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.vm_subnet.id
    nat       = false
    ip_address = "10.2.0.50"
  }
}

resource "yandex_vpc_network" "vm_vpc" {
  name = "vm_vpc"
  description = "vm network"
}

resource "yandex_vpc_subnet" "vm_subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vm_vpc.id
}