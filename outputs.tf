output "tunnel_token" {
  description = "The token for the created tunnel. Pass this to your cloudflared service."
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.app_tunnel_token
  sensitive   = false
}

output "tunnel_id" {
  description = "The ID of the created tunnel."
  value       = cloudflare_zero_trust_tunnel_cloudflared.app_tunnel
  sensitive = false
}

output "application_url" {
  description = "The public URL for your new Access application."
  value       = "https://${var.app_hostname}"
}