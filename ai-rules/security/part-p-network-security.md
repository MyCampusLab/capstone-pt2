# Network Security (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Network Security Controls

**Requirements:**
1. **Firewall Rules:**
   - Default deny (block all, allow explicit)
   - Whitelist IP ranges untuk admin access
   - Restrict database ports (3306, 5432) ke app servers only

2. **Web Application Firewall (WAF):**
   - OWASP Core Rule Set (CRS)
   - SQL injection protection
   - XSS protection
   - Rate limiting
   - Geographic blocking (jika applicable)

3. **DDoS Protection:**
   - CDN dengan DDoS mitigation (Cloudflare, AWS CloudFront)
   - Rate limiting di load balancer
   - Auto-scaling untuk absorb traffic spikes

4. **Network Segmentation:**
   - Public subnet: load balancer, web servers
   - Private subnet: app servers, databases
   - Management subnet: admin tools, monitoring
   - DMZ: bastion hosts, VPN endpoints

5. **VPN & Bastion:**
   - SSH access hanya via bastion host
   - VPN untuk remote access ke internal resources
   - MFA untuk VPN authentication

**Example: AWS Security Groups**
```
# Web server (public)
Inbound:
  - 80/tcp from 0.0.0.0/0 (HTTP)
  - 443/tcp from 0.0.0.0/0 (HTTPS)
Outbound:
  - All to app server SG

# App server (private)
Inbound:
  - 3000/tcp from web server SG
Outbound:
  - 3306/tcp to database SG

# Database (private)
Inbound:
  - 3306/tcp from app server SG
Outbound:
  - None
```

---

Kembali ke [Index](./README.md)
