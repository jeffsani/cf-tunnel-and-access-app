variable "cloudflare_account_id" {
  description = "Your Cloudflare Account ID."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Your Cloudflare Zone ID (for the domain)."
  type        = string
}

variable "tunnel_name" {
  description = "A name for your new Cloudflare Tunnel (e.g., 'webapp-prod-tunnel')."
  type        = string
  default     = "webapp-tunnel"
}

variable "app_hostname" {
  description = "The public hostname for your app (e.g., 'app.yourdomain.com')."
  type        = string
}

variable "private_origin_url" {
  description = "The private URL of your web app (e.g., 'https://192.168.1.10:8443' or 'http://localhost:8000')."
  type        = string
}

variable "origin_no_tls_verify" {
  description = "Set to true to disable TLS verification for the private origin (common for self-signed certs)."
  type        = bool
  default     = true
}

variable "auth_email_domain" {
  description = "The email domain to allow for Access authentication (e.g., 'yourcompany.com')."
  type        = string
}

variable "private_network_cidr" {
  description = "The private network CIDR to route through the tunnel (e.g., '192.168.0.0/24')."
  type        = string
}

variable "api_token" {
  description = "Your Cloudflare API Token with appropriate permissions."
  type        = string
}

variable "email" {
  description = "Your Cloudflare account email."
  type        = string
}
