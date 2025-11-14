# Copy this file to "terraform.tfvars" and fill in your values.
# Do not commit terraform.tfvars to source control.

cloudflare_account_id = "your-account-id-here"
cloudflare_zone_id    = "your-zone-id-here"
tunnel_name           = "prod-webapp-tunnel"
app_hostname          = "secure-app.yourdomain.com"
private_origin_url    = "https://192.168.0.100:8443"
origin_no_tls_verify  = true
auth_email_domain     = "yourcompany.com"