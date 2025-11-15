<pre style="color: rgb(255, 165, 0); background-color: #000; font-family: monospace; padding: 1em; display: inline-block; line-height: 1.2;">
                                     ,////////////.
                                   /////////////////////.
                                 //////////////////////////.
                                 /////////////////////////////.
                      ////////////////////////////////////////.
            /////////////////////////////////////////// .,,....
           .//////////////////////////////////////////  ,,,,,,,,,,.
           ./////////////////////////////////////////  ,,,,,,,,,,,,,..
    .////////////////////////////////////////////.      ,,,,,,,,,,,,,,.
 /////////////////                                           ,,,,,,._
 ///////////////////////////////////////////////     ,,,,,,,,,,,,,,,,,.
.////////////////////////////////////////////////  ,,,,,,,,,,,,,,,,,,,.
 ////////////////////////////////////////////////  ,,,,,,,,,,,,,,,,,,,..
</pre>

<H1>Terraform Scripts to Automate Access to a Private Application Deployment via Cloudflare Zero Trust</H1>
<H2>Description</H2>
This set of terraform files and linux script automates the setup of Cloudflare Zero Trust Access Application, Cloudflare Tunnel, and Tunnel Route.  The outputs include the public URL to access the application, the tunnel id and the token which you will pass to the linux script that will be used to install a Cloudflare Tunnel instance or replica.  An example shell script to use on the target host is also provided.

<H2>Prerequisites:</H2>
 - You must have an active Cloudflare Zone (domain).
 - Install Terraform (or use Terraform Cloud).
 - Set your Cloudflare API Token as an environment variable:


<H2>Configure Terraform:</H2>
 - Place all .tf files in a new directory.
 - Copy terraform.tfvars.example to terraform.tfvars.
 - Edit terraform.tfvars with your specific values (Account ID, Zone ID, hostname, etc.).
 - add *.tfvars to your .gitignore (or equivalent) if using version control

<H2>Apply Terraform:</H2>
 - Run terraform init to initialize the provider.
 - Run terraform apply to create the Cloudflare resources.
 - Review the plan and type yes when prompted.
 - After it completes, Terraform will output the tunnel_token. Copy this token.

<H2>Install Tunnel on Linux Host:</H2>
 - Copy the install_fips_tunnel.sh script to your Linux server (the one running your private web app).
 - Make the script executable: chmod +x install_fips_tunnel.sh.
 - Run the script with sudo, passing the token from the Terraform output:
 - Bash
   sudo ./install_fips_tunnel.sh <PASTE_YOUR_TUNNEL_TOKEN_HERE>

<H2>Verify:</H2>
 - On your Linux host, check the service status: sudo systemctl status cloudflared.
 - In your Cloudflare Zero Trust dashboard, check that your tunnel is "Healthy".
 - Open a browser and navigate to your app_hostname (e.g., https://secure-app.yourdomain.com). You should be prompted with the Cloudflare Access login screen.