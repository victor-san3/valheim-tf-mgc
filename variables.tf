variable "api_key" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud API Key"
}

variable "mgc_key_pair_id" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud key pair id"
}

variable "mgc_key_pair_secret" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud key pair secret"
}

variable "region" {
  type        = string
  description = "Default region"
}
