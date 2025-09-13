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