# Security Standard — Wajib untuk Semua Project

> **Status:** GUIDANCE + DATA FILE — AI WAJIB mematuhi standar ini di SEMUA project. Tidak bisa dinegosiasikan.
> **Purpose:** Security baseline yang HARUS diterapkan AI sejak awal development. Bukan optional.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Security is NOT Optional

Standar di bawah ini adalah **minimum security baseline**. AI WAJIB menerapkannya tanpa diminta. Jika ada yang belum diterapkan di project existing, AI WAJIB mengusulkan ke user.

**When to update:**
- Saat ada role/permission baru
- Saat auth flow berubah
- Saat ada security vulnerability yang ditemukan dan difix
- Saat ada perubahan struktur gate/policy

---

## Security Standard Index — Part A-Q

| Part | Focus | File | Key Rules |
|------|-------|------|-----------|
| **A** | Credential & Secret Management | [part-a-credential-management.md](./part-a-credential-management.md) | Semua secret di `.env`, DILARANG hardcode, DILARANG credential di .md di folder kode |
| **B** | HTTP Security Headers | [part-b-http-security-headers.md](./part-b-http-security-headers.md) | CSP, HSTS, X-Frame-Options — auto-setup by AI |
| **C** | Authentication & Authorization | [part-c-authentication-authorization.md](./part-c-authentication-authorization.md) | Password hashing, MFA, RBAC |
| **D** | Input Validation & Output Sanitization | [part-d-input-validation-output-sanitization.md](./part-d-input-validation-output-sanitization.md) | Semua endpoint POST/PUT/DELETE WAJIB validasi |
| **E** | Code Security Standards | [part-e-code-security-standards.md](./part-e-code-security-standards.md) | No eval, CORS, rate limiting, SAST/DAST |
| **F** | Authentication Flow | [part-f-authentication-flow.md](./part-f-authentication-flow.md) | Auth flow project-specific |
| **G** | Guards, Roles & Permissions | [part-g-guards-roles-permissions.md](./part-g-guards-roles-permissions.md) | RBAC implementation |
| **H** | Sensitive Operations | [part-h-sensitive-operations.md](./part-h-sensitive-operations.md) | CSRF, 2FA, audit trail |
| **I** | Security Pre-Merge Checklist | [part-i-security-pre-merge-checklist.md](./part-i-security-pre-merge-checklist.md) | Checklist sebelum merge ke main |
| **J** | Incident Response | [part-j-incident-response.md](./part-j-incident-response.md) | Prosedur tanggap insiden |
| **K** | Data Protection & Privacy | [part-k-data-protection-privacy.md](./part-k-data-protection-privacy.md) | GDPR, data masking, retention |
| **L** | Backup & Disaster Recovery Security | [part-l-backup-disaster-recovery-security.md](./part-l-backup-disaster-recovery-security.md) | Backup terenkripsi, restore testing |
| **M** | Container & Deployment Security | [part-m-container-deployment-security.md](./part-m-container-deployment-security.md) | Docker security, image scanning |
| **N** | WebSocket Security | [part-n-websocket-security.md](./part-n-websocket-security.md) | Auth, rate limit, input validation |
| **O** | GraphQL Security | [part-o-graphql-security.md](./part-o-graphql-security.md) | Query depth, complexity limit |
| **P** | Network Security | [part-p-network-security.md](./part-p-network-security.md) | Firewall, VPN, segmentation |
| **Q** | Security Monitoring & Alerting | [part-q-security-monitoring-alerting.md](./part-q-security-monitoring-alerting.md) | Logging, alerting, SIEM |

**WHEN TO READ WHAT:**
- **Read README.md** → understand the overview, pick which Part to read
- **Read specific Part** → when implementing that security aspect
- **Read Part I** → before every merge to main (pre-merge checklist)
