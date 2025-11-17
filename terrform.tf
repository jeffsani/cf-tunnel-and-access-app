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
  }
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_KEY
  email = var.CLOUDFLARE__EMAIL
}