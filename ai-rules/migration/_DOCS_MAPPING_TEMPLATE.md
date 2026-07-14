# Documentation Content Mapping — Panduan Kategorisasi Konten

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan saat melakukan Step 3: Map Content ke Folder Output.**

---

## Tabel Mapping: Jenis Konten → Folder Target

Gunakan tabel ini untuk mengkategorikan setiap konten dari old docs ke folder output yang sesuai.

### Planning (project masih dalam perencanaan)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Deskripsi project, goals, scope | "Tentang aplikasi ini", "Project overview", "Latar belakang" | `planning/PROJECT_BRIEF.md` |
| Product requirements, fitur list | "Fitur yang dibutuhkan", "User story", "Requirement" | `planning/prd.md` |
| Pemilihan teknologi, stack | "Tech stack", "Mengapa pakai framework X", "Library yang dipakai" | `planning/architecture.md` |
| Struktur database, entity list | "Table/collection", "Schema", "ERD", "Relasi" | `planning/database.md` |
| Modul/fitur breakdown | "List modul", "Module name", "Fitur per area" | `planning/modules.md` |
| API contract | "API endpoint", "REST API", "GraphQL schema" | `planning/api-contract.md` |
| UI/UX design, wireframe, mockup | "Halaman", "UI layout", "Design system" | `planning/wireframe.md` |
| Timeline, milestone, release plan | "Deadline", "Target rilis", "Sprint plan" | `planning/timeline.md` |

### dev-docs/ (living documentation, always up-to-date)

#### dev-docs/ai/ (AI internal docs)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| System overview, apa aplikasi ini | "About", "System description", "How it works" | `dev-docs/ai/PROJECT_CONTEXT.md` |
| Architectural patterns, design patterns | "Architecture", "Pattern", "Design decision" | `dev-docs/ai/PROJECT_MENTAL_MODEL.md` |
| Mapping: modul → file code | "Module X ada di folder Y", "Struktur folder" | `dev-docs/ai/MODULE_MAP.md` |
| Aturan coding, convention project | "Coding style", "Rule", "Konvensi" | `dev-docs/ai/CODING_RULES.md` |
| Status development terbaru | "Current state", "Progress", "Notes" | `dev-docs/ai/CURRENT_STATE.md` |
| Onboarding guide, cara mulai | "Getting started", "Setup guide", "First time" | `dev-docs/ai/START_HERE.md` |
| Active tasks, to-do | "Task list", "To do", "In progress" | `dev-docs/ai/TASKS.md` |
| Known bugs/issues | "Bug", "Issue", "Problem known" | `dev-docs/ai/KNOWN_ISSUES.md` |
| Technical debt | "Refactor needed", "Quick fix", "Technical debt" | `dev-docs/ai/TECHNICAL_DEBT.md` |
| Version history | "Version", "Release history" | `dev-docs/ai/VERSION.md` |

#### dev-docs/architecture/ (system design)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| API flow, request lifecycle | "API flow", "Request path", "Middleware" | `dev-docs/architecture/api-flow.md` |
| Backend folder structure | "Backend structure", "Folder organization" | `dev-docs/architecture/backend-structure.md` |
| Database schema, migrations | "Database design", "Schema", "Table relationship" | `dev-docs/architecture/database.md` |
| Frontend folder structure | "Frontend structure", "Component tree" | `dev-docs/architecture/frontend-structure.md` |

#### dev-docs/modules/ (per-module docs)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Dokumentasi spesifik modul | "Module X", "Fitur Y", nama modul/fitur | `dev-docs/modules/{modul}/README.md` |
| Permissions/gates per modul | "Permission", "Gate", "Access control" | `dev-docs/modules/{modul}/permissions.md` |
| API routes per modul | "Route", "Endpoint modul" | `dev-docs/modules/{modul}/routes.md` |

#### dev-docs/integrations/ (third-party)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Third-party API/service docs | "Integration", "Payment gateway", "Email service", "Midtrans", dll | `dev-docs/integrations/{service}.md` |

#### dev-docs/decisions/ (ADR)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Keputusan arsitektur penting | "Kenapa pakai X bukan Y", "Decision record" | `dev-docs/decisions/{NNN}-{description}.md` |

### prod-docs/ (server infrastructure)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Server specs, IP, hostname | "Server", "Production", "Infra", "Deployment" | `prod-docs/AGENTS.md` atau `prod-docs/docs/architecture/overview.md` |
| Network topology | "Network", "IP range", "Firewall", "Load balancer" | `prod-docs/docs/architecture/network-topology.md` |
| Tech stack per komponen (nginx, docker, db) | "Nginx config", "Docker compose", "Database setup" | `prod-docs/docs/tech-stack/{component}.md` |
| Deployment process | "Deploy step", "Release procedure" | `prod-docs/docs/operations/deployment.md` |
| Backup strategy | "Backup", "Restore", "Disaster recovery" | `prod-docs/docs/operations/backup.md` |
| Monitoring & alerting | "Monitoring", "Alert", "Grafana", "Prometheus" | `prod-docs/docs/operations/monitoring.md` |
| Security hardening | "Security", "Firewall", "Hardening" | `prod-docs/docs/operations/security.md` |

### REPORTS (maintenance + task reports)

| Jenis Konten | Indikator | Target File |
|-------------|-----------|-------------|
| Historical changelog/version | "Change log", "Release notes", "History" | `dev-docs/CHANGELOG.md` |
| Maintenance records | "Maintenance log", "Server audit", "Security scan" | `reports/maintenance/{tahun}/` |

---

## Common Scenarios

### Skenario A: Project sudah ada README.md yang lengkap

```
Old: docs/README.md (1 file besar, semua info di dalamnya)
New: split ke banyak file sesuai template

Extract dari README:
  - Section "About" → START_HERE.md + PROJECT_CONTEXT.md
  - Section "Tech Stack" → PROJECT_CONTEXT.md + planning/architecture.md
  - Section "Setup" → START_HERE.md
  - Section "Architecture" → dev-docs/architecture/
  - Section "API" → dev-docs/integrations/ atau modules/
  - Section "Deploy" → prod-docs/
```

### Skenario B: Wiki/Notion dengan banyak halaman

```
Old: Notion/wiki pages (export ke .md)
New: structured output

Kategorikan per halaman:
  - "/Getting-Started" → START_HERE.md
  - "/Architecture" → dev-docs/architecture/
  - "/API-Reference" → dev-docs/modules/ + dev-docs/integrations/
  - "/Deploy-Guide" → prod-docs/docs/operations/deployment.md
  - "/Coding-Standards" → dev-docs/ai/CODING_RULES.md
```

### Skenario C: Folder dokumentasi campur (docs + wiki + readme + random .md)

```
Old: banyak file .md tersebar
New: structured output

Proses:
  1. List semua file .md di semua folder
  2. Baca satu per satu
  3. Kategorikan per konten (bukan per lokasi file)
  4. Merge konten yang overlap ke file output yang sama
```

---

## Aturan Kategorisasi

1. **1 konten bisa masuk >1 file output** — konten yang relevan untuk 2 file harap dicopy ke keduanya (dengan penyesuaian format)
2. **Prioritaskan akurasi di atas kecepatan** — jika ragu kategorinya, tandai `{⚠️ NEEDS CLARIFICATION}` di laporan
3. **Jangan hapus konten** — semua konten dari old docs harus ada di minimal 1 file output atau di laporan sebagai "orphan content"
4. **Jangan duplikasi template** — jika konten sudah ada di template, biarkan template yang menang
5. **Updated content > old content** — jika old docs punya info yang bertentangan, tanya user mana yang benar
