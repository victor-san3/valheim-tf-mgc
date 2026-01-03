variable "api_key" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud API Key"
}

variable "mgc_key_pair_id" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud key pair id for bucket access"
}

variable "mgc_key_pair_secret" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud key pair secret for bucket access"
}

variable "region" {
  type        = string
  description = "Default region"
  default     = "br-se1"
}

variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token with DNS edit permissions for sanchez.dev.br"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID for sanchez.dev.br"
}
