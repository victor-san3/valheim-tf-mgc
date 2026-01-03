terraform {
  required_providers {
    mgc = {
      source  = "MagaluCloud/mgc"
      version = "0.41.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }
  }

  backend "s3" {
    bucket                      = "terraform-tf-state"
    key                         = "mgc/terraform.tfstate"
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

provider "mgc" {
  region  = var.region
  api_key = var.api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "tls" {
}
