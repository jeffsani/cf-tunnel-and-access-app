# 1. Create the Cloudflare Tunnel
# This resource replaces the deprecated 'cloudflare_zero_trust_tunnel_cloudflared'
resource "cloudflare_tunnel" "app_tunnel" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  # The secret is a 32-byte string. Terraform generates one if not provided.
}

# 2. Configure the Cloudflare Tunnel
# This resource replaces 'cloudflare_zero_trust_tunnel_cloudflared_config'
# Note the structure is 'config { ingress_rule { ... } }'
resource "cloudflare_tunnel_config" "app_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.app_tunnel.id

  config {
    ingress_rule {
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
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# 3. Create the Access Application
# This replaces 'cloudflare_zero_trust_access_application'
# Note there is NO 'policy' block inside this resource.
resource "cloudflare_access_application" "app_access" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  name       = "Access for ${var.app_hostname}"
  domain     = var.app_hostname
  type       = "self_hosted"

  # Session duration (e.g., "24h", "1h")
  session_duration = "24h"
}

# 4. Create the Access Policy
# This is the NEW way to define a policy.
# It is a separate resource linked to the application.
resource "cloudflare_access_policy" "app_policy" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.app_access.id
  zone_id        = var.cloudflare_zone_id

  name       = "Allow Authenticated Users"
  precedence = 1
  decision   = "allow"

  # This example allows any user from a specific email domain.
  include {
    email_domain = [var.auth_email_domain]
  }

  # You could also use this to allow *any* authenticated user
  # from your configured Identity Providers (IdPs).
  # require {
  #   authenticated = true
  # }
}