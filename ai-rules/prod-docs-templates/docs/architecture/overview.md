# Arsitektur Umum — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Server:** {hostname}
> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Ringkasan

{1-2 paragraf yang menjelaskan apa yang dijalankan server ini, arsitektur umum (monolith/microservices/containerized), dan komponen utama}

Contoh:
Server ini menjalankan **{nama_sistem}** dengan arsitektur **{monorepo_terpisah/microservices/monolith}** antara {list aplikasi}. Semua aplikasi berjalan di **Docker containers** di belakang **Nginx reverse proxy**.

---

## Diagram Arsitektur

```
                            ┌─────────────────┐
                            │   Load Balancer  │
                            │  (SSL Termination)│
                            └────────┬────────┘
                                     │ HTTP + X-Forwarded-Proto: https
                                     ▼
                            ┌─────────────────┐
                            │   Nginx 1.24    │
                            │  (port 80/443)  │
                            │  Reverse Proxy  │
                            └──┬──────┬──────┬┘
                               │      │      │
              ┌────────────────┘      │      └────────────────┐
              ▼                       ▼                       ▼
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │   {App 1}       │    │   {App 2}       │    │   {App 3}       │
    │  {Tech Stack}   │    │  {Tech Stack}   │    │  {Tech Stack}   │
    │  Docker:{port}  │    │  Docker:{port}  │    │  Docker:{port}  │
    └────────┬────────┘    └─────────────────┘    └────────┬────────┘
             │                                              │
             ▼                                              ▼
    ┌─────────────────┐                            ┌─────────────────┐
    │ {Database 1}    │                            │ {Database 2}    │
    │ {Host:Port}     │                            │ {Host:Port}     │
    └─────────────────┘                            └─────────────────┘
```

---

## Komponen Utama

| Komponen | Tech | Fungsi |
|----------|------|--------|
| **{App 1}** | {tech_stack} | {fungsi} |
| **{App 2}** | {tech_stack} | {fungsi} |
| **Nginx** | Nginx {version} | Reverse proxy, SSL, caching, rate limiting |
| **Redis** | Redis {version} | Cache & session |
| **{Database}** | {db_type} | Database utama |

---

## Server Specs

| Atribut | Nilai |
|---------|-------|
| Hostname | {hostname} |
| IP Internal | {ip_internal} |
| IP Database | {ip_database} |
| OS | {os_version} |
| Kernel | {kernel_version} |
| CPU | {cpu_cores} cores |
| RAM | {ram_gb} GB |
| Disk | {disk_size} |
| Domain | {domain} |

---

## Prinsip Arsitektur

{List prinsip arsitektur yang diterapkan di server ini}

Contoh:
1. **Containerization**: Semua aplikasi berjalan di Docker dengan hardening (cap_drop ALL, no-new-privileges, resource limits)
2. **Separation of Concerns**: Kode, storage, secrets, dan logs dipisah ke direktori terpisah
3. **Single Proxy Authority**: Nginx adalah satu-satunya otoritas untuk security headers, rate limiting, dan routing
4. **Pull-based Deploy**: Auto-deploy dari branch `main` GitHub via systemd timer
5. **Remote Database**: Database di server terpisah, bukan di server aplikasi
6. **Load Balancer**: Server berada di belakang LB yang melakukan SSL termination

---

## Data Flow

{Jelaskan bagaimana data mengalir melalui sistem}

Contoh:
1. User mengakses `https://domain.com`
2. Request masuk ke Load Balancer (SSL termination)
3. LB forward ke Nginx (HTTP + X-Forwarded-Proto: https)
4. Nginx routing ke container berdasarkan path/domain
5. App process request, query ke database
6. Response kembali melalui chain yang sama

---

## Deployment Strategy

{Jelaskan strategi deployment yang digunakan}

Contoh:
- **Blue-Green**: Dua environment identik, switch traffic setelah deploy
- **Rolling Update**: Update container satu per satu tanpa downtime
- **Pull-based**: Server auto-pull dari git repository setiap 1 menit
- **Manual**: Deploy manual via SSH dengan approval

---

## Scaling Considerations

{Jelaskan bagaimana sistem bisa di-scale jika diperlukan}

Contoh:
- **Horizontal**: Tambah instance container (docker compose up --scale)
- **Vertical**: Increase resource limits di docker-compose.yml
- **Database**: Read replicas, connection pooling
- **Cache**: Redis cluster untuk high availability

---

## Security Layers

{Jelaskan layer keamanan yang diterapkan}

1. **Network**: Firewall, security groups, private network
2. **Transport**: HTTPS only, TLS 1.3
3. **Application**: Rate limiting, input validation, CSRF protection
4. **Container**: Hardened containers, resource limits, no root
5. **Data**: Encrypted at rest, backup encryption
6. **Access**: SSH key only, 2FA, audit logging

---

## Monitoring & Observability

{Jelaskan bagaimana sistem dimonitor}

- **Metrics**: Prometheus + Grafana
- **Logs**: Centralized logging (ELK/Loki)
- **Alerts**: Email/Slack notifications
- **Health Checks**: Endpoint monitoring, uptime checks
- **APM**: Application performance monitoring

---

## Disaster Recovery

{Jelaskan strategi disaster recovery}

- **Backup**: Daily automated backup ke offsite storage
- **RTO**: Recovery Time Objective = {X hours}
- **RPO**: Recovery Point Objective = {Y hours}
- **Failover**: Manual/automatic failover ke secondary server
- **Testing**: Quarterly DR drill

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
