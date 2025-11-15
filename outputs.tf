output "tunnel_token" {
  description = "The token for the created tunnel. Pass this to your cloudflared service."
  value       = cloudflare_tunnel.app_tunnel.tunnel_token
  sensitive   = true
}

output "tunnel_id" {
  description = "The ID of the created tunnel."
  value       = cloudflare_tunnel.app_tunnel.id
}

output "application_url" {
  description = "The public URL for your new Access application."
  # This now correctly references the hostname variable
  value       = "https://${var.app_hostname}"
}