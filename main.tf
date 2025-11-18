
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
data "cloudflare_zero_trust_tunnel_cloudflared_token" "app_tunnel_token" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id
}

# 4. Configure the Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "app_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id
  source = "local"
  config = {
    ingress = [
      {
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
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

# 5. Create a Private Network Route
resource "cloudflare_zero_trust_tunnel_cloudflared_route" "private_network_route" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel.id
  network    = var.private_network_cidr
  comment    = "Route for private internal network"
}

# 6. Create the Access Policy
resource "cloudflare_zero_trust_access_policy" "app_policy" {
  account_id     = var.cloudflare_account_id
  name       = "Allow Authenticated Users"
  decision   = "allow"

  # This example allows any user from a specific email domain.
  include = [{
    email_domain = {
      domain = var.auth_email_domain
    }
  }]
}

# 7. Create the Access Application
resource "cloudflare_zero_trust_access_application" "app_access" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  name       = "${var.app_hostname} Access"
  domain     = var.app_hostname
  type       = "self_hosted"
  app_launcher_visible = true
  //allow_authenticate_via_warp = true
  //allow_iframe = true
  //allowed_idps = ["699d98642c564d2e855e9661899b7252"]
  //auto_redirect_to_identity = true
  # Session duration (e.g., "24h", "1h")
  session_duration = "24h"
  //custom_deny_message = "custom_deny_message"
  //custom_deny_url = "custom_deny_url"
  //custom_non_identity_deny_url = "custom_non_identity_deny_url"
  //custom_pages = ["699d98642c564d2e855e9661899b7252"]
  policies = [{
    id = cloudflare_zero_trust_access_policy.app_policy.id
    precedence = 1
  }]
}

