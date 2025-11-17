provider "cloudflare" {
  # Your Cloudflare API Token should be set as an
  # environment variable: export CLOUDFLARE_API_TOKEN="your_token_here"
}

# 1. Create a random secret for the tunnel
# We must use this to create the tunnel and the token
resource "random_password" "tunnel_secret" {
  length  = 32
  special = false
}

# 2. Create the Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "app_tunnel" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  # Pass in the secret as a base64-encoded string
  tunnel_secret = base64encode(random_password.tunnel_secret.result)
}

# 3. Get the Token for the Tunnel
resource "cloudflare_tunnel_token" "app_tunnel_token" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id
}

# 4. Configure the Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "app_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id

  config = {
    ingress = {
      hostname = var.app_hostname
      service  = var.private_origin_url

      origin_request = {
        no_tls_verify = true
        //ca_pool = "caPool"
        //connect_timeout = 10
        //disable_chunked_encoding = true
        //http2_origin = true
        //http_host_header = "httpHostHeader"
        //keep_alive_connections = 100
        //keep_alive_timeout = 90
        //no_happy_eyeballs = false
        //origin_server_name = "originServerName"
        //proxy_type = "proxyType"
        //tcp_keep_alive = 30
        //tls_timeout = 10
      }
    }
  }
}

# 5. Create a Private Network Route
resource "cloudflare_zero_trust_tunnel_cloudflared_route" "private_network_route" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id
  network    = var.private_network_cidr
  comment    = "Route for private internal network"
}

# 6. Create the Access Application
resource "cloudflare_zero_trust_access_application" "app_access" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  name       = "Access for ${var.app_hostname}"
  domain     = var.app_hostname
  type       = "self_hosted"

  # Session duration (e.g., "24h", "1h")
  session_duration = "24h"
}

# 7. Create the Access Policy
resource "cloudflare_zero_trust_access_policy" "app_policy" {
  account_id     = var.cloudflare_account_id
  name       = "Allow Authenticated Users"
   decision   = "allow"

  # This example allows any user from a specific email domain.
  include = {
    email_domain = [var.auth_email_domain]
  }
}