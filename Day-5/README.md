# Day 5 – Terraform + MIG + Load Balancer

This setup provisions:
- Instance Template (with Apache startup script)
- Managed Instance Group (2 instances)
- Firewall rule (allow HTTP)
- HTTP Load Balancer (global)

## How to Deploy
```bash
terraform init
terraform apply -auto-approve
Verify
Get the forwarding rule IP:
gcloud compute forwarding-rules list --global
Open in browser: http://<FORWARDING_RULE_IP>

You should see:
Hello from MIG Instance <hostname>

Debugging
Check Apache status:
    sudo systemctl status apache2
Check startup script logs:
    sudo journalctl -u google-startup-scripts.service
Check Load Balancer health:
    gcloud compute backend-services get-health backend-service --global


---
