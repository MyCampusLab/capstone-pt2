# Architecture Plan — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Dibuat sebelum development. Jangan diubah tanpa diskusi.
> **Purpose:** Cetak biru teknis: stack, system design, komponen, deployment architecture.

---

##  Project Type Declaration

| Item | Value |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |
| Git Location | `{apps/ — single repo} / {backend/ dan frontend/ — dual repo}` |

---

## 1. Tech Stack

| Layer | Technology | Version | Rationale |
|-------|-----------|---------|----------|
| Backend | `{framework}` | `{versi}` | `{alasan pemilihan}` |
| Frontend | `{framework}` | `{versi}` | `{alasan pemilihan}` |
| Database | `{engine}` | `{versi}` | `{alasan pemilihan}` |
| Cache | `{engine}` | `{versi}` | |
| Queue | `{engine}` | `{versi}` | |
| Search | `{engine}` | `{versi}` | |
| Storage | `{engine}` | — | |
| Web Server | `{engine}` | `{versi}` | |

---

## 2. System Design

### Architecture Pattern

`{Monolith / Modular Monolith / Microservices / Layered Architecture}`

**Alasan:** `{kenapa pola ini dipilih}`

### High-Level Diagram

```text
{deskripsi tekstual alur sistem — bisa diganti diagram nanti}

[Client] → [Nginx] → [Backend PHP/Node/Go] → [DB]
                           ↓
                      [Cache/Redis]
                           ↓
                      [Queue Worker] → [External API]
```

---

## 3. Component Breakdown

| Komponen | Tipe | Tanggung Jawab | Teknologi |
|----------|------|---------------|----------|
| `{API Server}` | Backend | `{deskripsi}` | `{tek}` |
| `{Admin Panel}` | Frontend | `{deskripsi}` | `{tek}` |
| `{Public Site}` | Frontend | `{deskripsi}` | `{tek}` |
| `{Worker}` | Background | `{deskripsi}` | `{tek}` |

---

## 4. Routing & Middleware Strategy

### Monolith (Laravel/Node)
- Route groups per module
- Middleware: auth, role, permission
- Namespace convention

### Fullstack (API + SPA)
- API prefix: `/api/v1`
- Auth: token-based (Sanctum/JWT/Session)
- CORS policy

---

## 5. Data Flow

```text
{deskripsi bagaimana data mengalir antar komponen}

[Form Submit] → [Validate] → [Controller] → [Service] → [DB]
                                  ↓
                            [Queue Job] → [Notify]
```

---

## 6. Security Plan

| Area | Strategy |
|------|----------|
| Authentication | `{strategy}` |
| Authorization | `{RBAC / ABAC / custom}` |
| CSRF | `{protection}` |
| XSS | `{output escaping}` |
| SQL Injection | `{ORM / prepared statements}` |
| File Upload | `{validation + storage}` |

---

## 7. Deployment Architecture

```
{Environment} → {Server} → {CI/CD} → {Monitoring}
```

| Environment | Server | Domain | Branch |
|------------|--------|--------|--------|
| Local | `{localhost}` | — | `dev/feat` |
| Staging | `{server}` | `{staging.example.com}` | `dev` |
| Production | `{server}` | `{example.com}` | `main` |

---

## 8. Key Decisions

| # | Keputusan | Alasan | ADR |
|---|----------|--------|-----|
| 1 | `{keputusan}` | `{alasan}` | `dev-docs/decisions/001-*.md` |
