variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token with DNS edit permissions for sanchez.dev.br"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID for sanchez.dev.br"
}

variable "proxmox_username" {
  type        = string
  description = "Proxmox username"
}

variable "proxmox_password" {
  type        = string
  sensitive   = true
  description = "Proxmox password"
}

variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox endpoint"
}

variable "pve1_address" {
  type        = string
  description = "Proxmox node 1 address"
}

variable "pve2_address" {
  type        = string
  description = "Proxmox node 2 address"
}

variable "pve3_address" {
  type        = string
  description = "Proxmox node 3 address"
}
