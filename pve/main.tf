terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.90.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }

  backend "s3" {
    bucket                      = "terraform-tf-state"
    key                         = "pve/terraform.tfstate"
    region                      = "br-se1"
    profile                     = "mgc"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    endpoints = {
      s3 = "https://br-se1.magaluobjects.com/"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint

  username = var.proxmox_username
  password = var.proxmox_password

  insecure = true

  random_vm_ids      = true
  random_vm_id_start = 100
  random_vm_id_end   = 300

  ssh {
    password = var.proxmox_password

    node {
      name    = "pve1"
      address = var.pve1_address
    }
    node {
      name    = "pve2"
      address = var.pve2_address
    }
    node {
      name    = "pve3"
      address = var.pve3_address
    }
  }
}

data "proxmox_virtual_environment_file" "ubuntu_iso" {
  node_name    = "pve1"
  datastore_id = "local"
  content_type = "iso"
  file_name    = "noble-server-cloudimg-amd64.img"
}
