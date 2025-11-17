terraform {
  cloud {
    organization = "JPS_Consulting"
    workspaces {
      name = "Deploy-CF-Tunnel-Access-App"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
    email = var.CLOUDFLARE_EMAIL
    api_key = var.CLOUDFLARE_API_KEY
}