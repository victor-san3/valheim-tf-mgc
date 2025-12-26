resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "test-ubuntu"
  node_name = "pve1"

  stop_on_destroy = true

  initialization {
    user_account {
      username = "user"
      password = "password"
    }

    ip_config {
      ipv4 {
        address = "dhcp"
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

  # Enable QEMU guest agent for cloud-init
  agent {
    enabled = true
  }

  # Network interface - uses default vmbr0 bridge
  network_device {
    bridge = "vmbr0"
  }
}

# NOTE: The download_file resource has a bug with Proxmox API causing "proxy loop detected".
# Workaround: Manually download the image on pve1:
#   wget -O /var/lib/vz/template/cache/noble-server-cloudimg-amd64.img \
#     https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
