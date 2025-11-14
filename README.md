
This set of terraform files and linux script automates the setup of Cloudflare Zero Trust Access Application, Cloudflare Tunnel, 


Prerequisites:
- You must have an active Cloudflare Zone (domain).

Install Terraform (or use Terraform Cloud).

 - Set your Cloudflare API Token as an environment variable:

 - Bash
   sudo ./install_fips_tunnel.sh <PASTE_YOUR_TUNNEL_TOKEN_HERE>

 - export CLOUDFLARE_API_TOKEN="your_api_token_here"


Configure Terraform:

 - Place all .tf files in a new directory.

 - Copy terraform.tfvars.example to terraform.tfvars.

 - Edit terraform.tfvars with your specific values (Account ID, Zone ID, hostname, etc.).

 - add *.tfvars to your .gitignore (or equivalent) if using version control

Apply Terraform:

 - Run terraform init to initialize the provider.

 - Run terraform apply to create the Cloudflare resources.

 - Review the plan and type yes when prompted.

 - After it completes, Terraform will output the tunnel_token. Copy this token.

Install Tunnel on Linux Host:

 - Copy the install_fips_tunnel.sh script to your Linux server (the one running your private web app).

 - Make the script executable: chmod +x install_fips_tunnel.sh.

 - Run the script with sudo, passing the token from the Terraform output:

 - Bash
   sudo ./install_fips_tunnel.sh <PASTE_YOUR_TUNNEL_TOKEN_HERE>

Verify:

 - On your Linux host, check the service status: sudo systemctl status cloudflared.

 - In your Cloudflare Zero Trust dashboard, check that your tunnel is "Healthy".

 - Open a browser and navigate to your app_hostname (e.g., https://secure-app.yourdomain.com). You should be prompted with the Cloudflare Access login screen.