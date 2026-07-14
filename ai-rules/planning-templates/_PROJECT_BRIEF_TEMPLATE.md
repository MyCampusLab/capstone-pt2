# PROJECT BRIEF — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** OPTIONAL — Tiga cara pakai:
> - **Mode A (Manual):** Copy & isi file ini → prompt AI: "baca PROJECT_BRIEF.md dan isi planning docs"
> - **Mode B (Interaktif):** Biarkan file ini kosong/tidak ada → prompt AI bebas. AI akan mendeteksi tidak ada brief lalu bertanya interaktif, menulis file ini, lalu memproses planning.
> - **Mode C (Hybrid):** Isi section yang kamu tahu saja, kosongkan sisanya — AI akan bertanya untuk mengisi kekosongan.
>
> **Sections bertanda ⭐ wajib diisi (minimal).** Sisanya opsional — hapus jika tidak relevan, tapi semakin lengkap semakin detail hasil planning AI.

---

## 1. Vision ⭐

### Elevator Pitch

**{1-3 kalimat — apa produk ini, untuk siapa, dan nilai utamanya}**

Contoh: "EAG adalah platform Virtual Engineering Team yang memungkinkan satu developer bekerja dengan banyak AI Agent spesialis menggunakan berbagai provider dan model AI secara terpusat — provider-agnostic, model-agnostic, dan cost-efficient."

### Problem Statement ⭐

**{Masalah spesifik apa yang diselesaikan? Sebutkan pain points user saat ini — pakai bullet list.}**

- `{pain_point_1}`
- `{pain_point_2}`
- `{pain_point_3}`

### Target Users ⭐

| Role | Deskripsi | Kebutuhan Utama |
|------|----------|----------------|
| `{role_1}` | `{deskripsi}` | `{kebutuhan — apa yang mereka butuhkan dari sistem ini}` |
| `{role_2}` | `{deskripsi}` | `{kebutuhan}` |

---

## 2. Project Type & Tech Stack ⭐

| Item | Pilih |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |
| Backend | `{Go-Fiber / Laravel / Node.js-Express / NestJS / Python-FastAPI / lainnya}` |
| Framework Version | `{versi}` |
| Frontend | `{Nuxt / Next.js / React / Vue / Blade / tidak ada}` — kosongkan jika monolith backend-only |
| Database | `{PostgreSQL / MySQL / SQLite / MongoDB}` |
| Vector Search | `{pgvector / Meilisearch / Elasticsearch / tidak ada}` — jika butuh semantic search |
| Cache | `{Redis / Memcached / tidak ada}` |
| Queue / Message Broker | `{Redis Streams / RabbitMQ / SQS / tidak ada}` |
| Object Storage | `{MinIO / S3 / Local / tidak ada}` — untuk file upload |
| Monitoring | `{Prometheus+Grafana / Sentry / Grafana Loki / tidak ada}` |
| Logging | `{Loki / ELK / file-based / tidak ada}` |
| CI/CD | `{GitHub Actions / GitLab CI / manual / tidak ada}` |
| Deployment | `{Docker Compose / Kubernetes / VPS manual / lainnya}` |
| Arsitektur | `{Modular Monolith / Microservices / Layered / Hexagonal}` |

---

## 2b. UI/UX Template & Design System ⭐

**PENTING: Section ini menentukan bagaimana AI membuat frontend UI.**

### Apakah ada HTML Template yang disediakan?

**Pilih salah satu:**

| Opsi | Deskripsi | Konsekuensi |
|------|-----------|-------------|
| **YA** | User menyediakan template HTML siap pakai (contoh: Metronic 8, AdminLTE, Stisla) | AI **WAJIB** menggunakan template, **DILARANG** membuat UI sendiri dari nol |
| **TIDAK** | Tidak ada template HTML | AI **BOLEH** membuat UI, tapi **WAJIB** pakai framework UI established (Bootstrap, Tailwind, Material UI, dll), **DILARANG** buat custom CSS dari nol |

**Jawaban:** `{YA / TIDAK}`

### Jika YA — Detail Template HTML

| Item | Value |
|------|-------|
| Nama Template | `{contoh: Metronic 8, AdminLTE 3, Stisla}` |
| Versi | `{versi template}` |
| Lokasi Template | `{path ke folder template — contoh: dev-docs/reference/template/metronic/}` |
| Dokumentasi Template | `{URL dokumentasi resmi atau path ke file dokumentasi lokal}` |
| Lisensi | `{Regular License / Extended License / Custom}` |
| Komponen yang Akan Dipakai | `{contoh: Dashboard, Tables, Forms, Charts, Auth pages}` |

**Aturan untuk AI:**
- **WAJIB** menggunakan struktur HTML, CSS, dan komponen dari template
- **WAJIB** mengikuti naming convention dan class names dari template
- **DILARANG** membuat UI components sendiri yang sudah ada di template
- **DILARANG** override styling template kecuali sangat diperlukan
- **BOLEH** extend/customize komponen template jika fitur tidak tersedia

### Jika TIDAK — Framework UI yang Harus Dipakai

| Item | Value |
|------|-------|
| Framework UI | `{Bootstrap 5 / Tailwind CSS / Material UI / Ant Design / Bulma / Foundation}` |
| Versi | `{versi framework}` |
| Theme/Style Guide | `{jika ada — contoh: "Gunakan Bootstrap dengan style default"}` |
| Custom Components | `{jika perlu — contoh: "Buat custom navbar dan sidebar"}` |

**Aturan untuk AI:**
- **WAJIB** menggunakan framework UI yang dipilih
- **WAJIB** mengikuti best practices framework (contoh: Bootstrap grid system, Tailwind utility classes)
- **DILARANG** membuat CSS framework custom dari nol
- **BOLEH** membuat custom CSS hanya untuk komponen yang tidak ada di framework
- **BOLEH** menggunakan pre-built components dari framework

### Catatan Tambahan (Opsional)

`{Preferensi UI/UX khusus, style guide, color palette, typography, atau referensi desain lainnya}`

---

## 3. Core Features (MVP) ⭐

**{List SEMUA fitur yang HARUS ada di rilis pertama. Bukan abstrak — sebutkan nama fitur konkret yang akan jadi modul.}**

- `{fitur_1}`
- `{fitur_2}`
- `{fitur_3}`
- `{fitur_4}`
- `{fitur_5}`
- `{fitur_6}`
- `{fitur_7}`
- `{fitur_8}`
- `{fitur_9}`
- `{fitur_10}`

---

## 4. Non-Goals / Out of Scope ⭐

**{Apa yang TIDAK akan dibangun di Phase 1? Ini KRUSIAL — mencegah scope creep.}**

- `{item_1}`
- `{item_2}`
- `{item_3}`
- `{item_4}`
- `{item_5}`

---

## 5. User Roles & Permissions ⭐

| Role | Deskripsi | Level Akses | Module Scope |
|------|----------|------------|-------------|
| `{role_1}` | `{deskripsi}` | `{Full / Admin / Write / Read}` | `{semua modul / modul tertentu}` |
| `{role_2}` | `{deskripsi}` | | |
| `{role_3}` | `{deskripsi}` | | |

---

## 6. Core Business Logic & Rules ⭐

**{Aturan bisnis yang HARUS di-enforce oleh sistem. Gunakan format "JIKA ... MAKA ...". Jangan tulis aturan teknis (validasi, auth) — itu default. Tulis aturan BISNIS spesifik.}**

- `{aturan_1 — contoh: "JIKA task status = In Review MAKA hanya Reviewer Agent yang boleh mengubah status"}`
- `{aturan_2 — contoh: "JIKA budget tersisa < 20% MAKA notifikasi ke user dan batasi provider premium"}`
- `{aturan_3}`
- `{aturan_4}`

---

## 7. Key Workflows

**{Flow utama dalam aplikasi. Deskripsikan langkah-langkahnya secara berurutan. Satu workflow = satu sub-section.}**

### Workflow: {Nama Workflow 1}

```text
{Langkah 1} → {Langkah 2} → {Langkah 3} → {Langkah 4} → {Langkah 5}
```

**Aturan:** `{apakah workflow ini wajib berurutan? Bisa skip step?}`

### Workflow: {Nama Workflow 2}

```text
{Langkah 1} → {Langkah 2} → ...
```

---

## 8. Architecture Philosophy (Opsional — untuk project kompleks)

**{Jika project ini punya prinsip arsitektur khusus. Contoh: "Provider-agnostic", "Model-agnostic", "Event-driven", "CQRS".}**

### {Prinsip 1}

`{penjelasan singkat — apa maksudnya dan kenapa penting}`

### {Prinsip 2}

`{penjelasan singkat}`

### Contoh arsitektur (jika membantu):

```text
{Layer 1} → {Layer 2} → {Layer 3} → {Layer 4}
```

---

## 9. Core Engine / System Design (Opsional — untuk project dengan engine kompleks)

**{Jika project ini punya komponen inti yang non-standar. Jelaskan cara kerjanya.}**

### {Nama Komponen Inti}

**Tugas:**

- `{tanggung_jawab_1}`
- `{tanggung_jawab_2}`

**Input:**

```yaml
{parameter_1}:
{parameter_2}:
```

**Output:**

```yaml
{output_1}:
{output_2}:
```

---

## 10. Integration Points

**{Apakah aplikasi ini perlu terhubung dengan layanan eksternal?}**

| Service | Type | Purpose | Auth Method | Critical? |
|---------|------|---------|-----------|----------|
| `{nama_service}` | `{REST API / SDK / Webhook / SMTP}` | `{tujuan}` | `{API Key / OAuth2}` | ✅ / ❌ |

---

## 11. Key Architecture Decisions

**{Keputusan arsitektur penting yang sudah dipikirkan. Kalau belum — kosongkan, AI akan usulkan.}**

- `{contoh: "Provider-agnostic: sistem tidak boleh hardcode provider. Provider terdaftar di registry."}`
- `{contoh: "Capability-driven routing: Agent hanya minta capability, Router yang pilih provider+model."}`
- `{contoh: "Modular monolith: dipisah per domain bisnis, tapi satu deployable unit."}`

---

## 12. Success Criteria ⭐

**{Bagaimana kita tahu project ini sukses? Gunakan metrik yang terukur.}**

| Metric | Target | Cara Ukur |
|--------|--------|----------|
| `{metrik_1}` | `{target — contoh: "Provider lock-in = 0%"}` | `{bagaimana diverifikasi}` |
| `{metrik_2}` | `{target}` | |
| `{metrik_3}` | `{target}` | |
| `{metrik_4}` | `{target}` | |

---

## 13. Data & References

**{File Excel, PDF, SOP, sistem lama, atau referensi lain yang jadi acuan.}**

- `{path/ke/file — nanti ditaruh di dev-docs/reference/}`
- `{URL dokumentasi — jika ada}`

---

## 14. Timeline & Constraints

| Item | Value |
|------|-------|
| Target rilis MVP | `{YYYY-MM-DD — opsional}` |
| Jumlah user (estimasi) | `{angka}` |
| Batasan budget | `{opsional}` |
| Batasan waktu | `{opsional}` |
| Batasan tim | `{opsional — contoh: "Hanya 1 fullstack developer"}` |
| Batasan infrastruktur | `{opsional — contoh: "Single server, Docker Compose only"}` |

---

## 15. Final Goal / North Star ⭐

**{1 kalimat — apa tujuan akhir dari project ini? Kalimat yang mengarahkan SEMUA keputusan desain dan prioritas.}**

Contoh: "Membangun platform Virtual Engineering Team yang memungkinkan satu developer bekerja dengan banyak AI Agent spesialis menggunakan berbagai provider dan model AI secara otomatis melalui workflow engineering yang konsisten, scalable, provider-agnostic, dan cost-efficient."

---

## 16. Tambahan / Brain Dump (Opsional)

**{Apa pun yang belum tercakup di atas — ide, kekhawatiran, inspirasi, coretan. Jangan di-edit — tulis mentah-mentah. AI akan mengolahnya.}**

- `{brain_dump_1}`
- `{brain_dump_2}`
