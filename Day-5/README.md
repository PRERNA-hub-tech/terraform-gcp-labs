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
# Day 6 – Cloud Storage + Load Balancer + Cloud CDN

## Setup Overview
- Created a **GCS bucket** for static content.
- Configured **Backend Bucket** to link GCS bucket with LB.
- Built **HTTP Load Balancer** (global IP, forwarding rule, proxy, URL map).
- Enabled **Cloud CDN** on backend bucket.
- Verified cache HIT/MISS using curl commands.

## Flow
1. User → Load Balancer IP.
2. Load Balancer checks backend bucket.
3. Cloud CDN serves from cache (if HIT) or fetches from bucket (if MISS).
4. Response delivered with low latency.

## Verification Commands
```bash
curl -I http://<LB_IP>             # Normal request
curl -I "http://<LB_IP>?nocache=1" # Force MISS
curl -I -H "Cache-Control: no-cache" http://<LB_IP>

Key Learnings

Backend bucket uses existing GCS bucket (not new one).

Buckets can be private; LB fetches objects.

Cloud CDN reduces latency & backend load.

Age header confirms cache HIT