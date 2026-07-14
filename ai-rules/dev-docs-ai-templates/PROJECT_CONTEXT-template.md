# PROJECT_CONTEXT

> **Status:** GUIDANCE + DATA FILE — AI mengisi data project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Overview sistem, stack teknologi, dan struktur project.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Setelah menganalisis codebase, BUAT semua section di bawah ini di FILE OUTPUT (bukan di template ini):. Gunakan format tabel untuk data terstruktur.

**When to update:**
- Pertama kali analisis project
- Saat ada penambahan/penggantian teknologi
- Saat ada restrukturisasi folder besar
- Saat ada perubahan database topology

**Uncertainty rule:** Area yang belum tervalidasi lewat test/integration runtime harus ditulis sebagai: **Assumption based on repository analysis**.

---

## System Overview

**Isi dengan 1-3 paragraf yang menjelaskan:**
- Apa aplikasi ini
- Siapa penggunanya
- Tujuan bisnis/teknis utama
- Konteks organisasi (jika relevan)

---

##  Project Type Declaration

| Item | Value |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |
| Git Location | `{apps/ — single repo} / {backend/ dan frontend/ — dual repo}` |

**AI WAJIB mengisi ini saat pertama analisis.** Semua perintah git bergantung pada deklarasi ini.

---

## Runtime Stack

| Layer | Technology |
|-------|-----------|
| Backend | `{framework_bahasa}` |
| Frontend | `{framework_ui}` |
| Database Primary | `{db_utama}` |
| Database Secondary | `{db_sekunder — hapus baris jika tidak ada}` |
| Cache | `{redis_memcached_dll}` |
| Queue | `{redis_beanstalk_sqs_dll}` |
| Search | `{elasticsearch_meilisearch_dll}` |
| Storage | `{s3_local_dll}` |
| Web Server | `{nginx_apache_octane_dll}` |

---

## UI/UX Template & Framework

**Isi berdasarkan deklarasi di `planning/PROJECT_BRIEF.md` section "UI/UX Template & Design System".**

### Template Status

| Item | Value |
|------|-------|
| Template HTML Provided? | `{YA / TIDAK}` |
| Template Name | `{nama template atau "N/A"}` |
| Template Version | `{versi atau "N/A"}` |
| Template Location | `{path ke folder template atau "N/A"}` |
| UI Framework | `{Bootstrap 5 / Tailwind / Material UI / dll}` |
| Framework Version | `{versi}` |

### AI Rules (Based on Template Status)

**Jika Template HTML = YA:**
- ✅ **WAJIB** menggunakan struktur HTML, CSS, dan komponen dari template
- ✅ **WAJIB** mengikuti naming convention dan class names dari template
- ❌ **DILARANG** membuat UI components sendiri yang sudah ada di template
- ❌ **DILARANG** override styling template kecuali sangat diperlukan
- ✅ **BOLEH** extend/customize komponen template jika fitur tidak tersedia

**Jika Template HTML = TIDAK:**
- ✅ **WAJIB** menggunakan framework UI yang dipilih (lihat tabel di atas)
- ✅ **WAJIB** mengikuti best practices framework
- ❌ **DILARANG** membuat CSS framework custom dari nol
- ✅ **BOLEH** membuat custom CSS hanya untuk komponen yang tidak ada di framework
- ✅ **BOLEH** menggunakan pre-built components dari framework

### Template Components Mapping (Jika Template HTML = YA)

**Isi setelah analisis template:**

| Component Needed | Template Component | Location in Template |
|------------------|-------------------|---------------------|
| `{contoh: Login Page}` | `{contoh: authentication/login.html}` | `{path}` |
| `{contoh: Dashboard}` | `{contoh: dashboards/default.html}` | `{path}` |
| `{contoh: Data Table}` | `{contoh: tables/datatables.html}` | `{path}` |

---

## Database Topology

| Connection | Domain / Schema | Notes |
|-----------|----------------|-------|
| `{nama_koneksi}` | `{domain_data}` | `{catatan}` |

---

## Source Structure (Important)

| Path | Function |
|------|----------|
| `{path/ke/direktori}` | `{fungsi direktori tersebut}` |

---

## Current Architecture Direction

**Isi dengan arah arsitektur saat ini:**
- Apakah monolith, modular monolith, microservices?
- Apakah sedang dalam transisi?
- Pola komunikasi antar komponen?

---

## Uncertainty Markers

**Isi dengan asumsi yang belum terverifikasi:**

- Assumption based on repository analysis: `{asumsi_1}`
- Assumption based on repository analysis: `{asumsi_2}`
