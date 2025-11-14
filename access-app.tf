# 1. Create the Cloudflare Tunnel
# This resource creates the tunnel itself and provides the token needed
# for the cloudflared connector to authenticate.
resource "cloudflare_zero_trust_tunnel_cloudflared" "app_tunnel" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
}

# 2. Configure the Cloudflare Tunnel
# This resource defines the ingress rules for your tunnel,
# pointing your public hostname to your private origin service.
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "app_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id

  config {
    ingress {
      hostname = var.app_hostname
      service  = var.private_origin_url

      dynamic "origin_request" {
        for_each = var.origin_no_tls_verify ? [1] : []
        content {
          no_tls_verify = true
        }
      }
    }

    # A catch-all rule to return 404 for any other requests
    ingress {
      service = "http_status:404"
    }
  }
}

# 3. Create the Access Application
# This resource secures your public hostname, requiring users
# to authenticate before they can access the application.
resource "cloudflare_zero_trust_access_application" "app_access" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  name       = "Access for ${var.app_hostname}"
  domain     = var.app_hostname
  type       = "self_hosted"

  # Session duration (e.g., "24h", "1h")
  session_duration = "24h"

  # This policy requires any user who can authenticate with your
  # configured Identity Providers (IdPs) to be allowed.
  # You can make this more restrictive (e.g., by email, group, etc.)
  policy {
    name       = "Allow Authenticated Users"
    precedence = 1
    decision   = "allow"

    include {
      # This example allows any user from a specific email domain.
      # For a simpler "allow anyone who can log in",
      # you could use `authenticated = true` if you have an IdP set up.
      email_domain = [var.auth_email_domain]
    }
  }
}