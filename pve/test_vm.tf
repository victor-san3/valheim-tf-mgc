resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "test-ubuntu"
  node_name = "pve1"

  stop_on_destroy = true

  initialization {
    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = random_password.ubuntu_vm_password.result
      username = "ubuntu"
    }

    ip_config {
      ipv4 {
        address = "192.168.15.${random_integer.ip_offset.result}/24"
        gateway = "192.168.15.1"
      }
    }
  }

  disk {
    file_id   = "local:iso/${data.proxmox_virtual_environment_file.ubuntu_iso.file_name}"
    interface = "virtio0"
    iothread  = true
    discard   = "on"
    cache     = "writeback"
    size      = 12
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  keyboard_layout = "pt-br"

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "random_integer" "ip_offset" {
  min = 60
  max = 90
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_openssh
  sensitive = true
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}
