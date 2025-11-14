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


