//Use terraform output -raw tunnel_token to get the token value without quotes from the cli
//Use terraform output -raw tunnel_id to get the tunnel ID value without quotes from the cli

output "tunnel_token" {
  description = "The token for the created tunnel. Pass this to your cloudflared service."
  value       = nonsensitive(data.cloudflare_zero_trust_tunnel_cloudflared_token.app_tunnel_token)
  sensitive   = true
}

output "tunnel_id" {
  description = "The ID of the created tunnel."
  value       = nonsensitive(cloudflare_zero_trust_tunnel_cloudflared.app_tunnel)
  sensitive = true
}

output "application_url" {
  description = "The public URL for your new Access application."
  value       = "https://${var.app_hostname}"
}