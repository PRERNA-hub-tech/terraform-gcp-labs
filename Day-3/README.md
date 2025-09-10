Day 3 – Networking (VPC, Subnets, Firewall)

Concepts:

VPC (Virtual Private Cloud)

Global resource that defines private network in GCP.

Default VPC (auto subnets) vs. Custom VPC (you define subnets).

Subnet

Regional resource, defines IP range (10.0.0.0/24).

VMs are attached to subnet → get private IP.

Firewall rules

Define allowed traffic to/from resources.

Example: allow SSH (22), HTTP (80).

Rules applied at VPC level.

Access config in network block

Attaches a public IP (nat_ip) so VM is reachable from internet.

Without it → VM only has internal IP (private).

Interview Pointers:

Q: What’s the difference between VPC and Subnet?

VPC = container for networking.

Subnet = slice of IP addresses inside VPC, tied to region.

Q: Why disable auto_create_subnetworks?
A: For production, we want custom control over IP ranges, firewall rules, and security.

Q: How does firewall in GCP work?
A: Stateful → If inbound connection allowed, response traffic is automatically allowed.

Q: What is the significance of access_config {}?
A: Allocates external IP to VM, making it reachable over internet. Without it → private VM.