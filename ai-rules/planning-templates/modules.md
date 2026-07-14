# Module Breakdown — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Dibuat sebelum development. Jangan diubah tanpa diskusi.
> **Purpose:** Breakdown modul/fitur, dependency, prioritas build.

---

##  Project Type Declaration

| Item | Value |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |

**Fullstack:** tambahkan kolom **Repo** (`backend` / `frontend` / `both`) di setiap entry. Module "Auth" misalnya: route & logic di backend, halaman login di frontend.

---

## 1. Module Map

| # | Module | Deskripsi | Repo | Priority | Dependencies |
|---|--------|----------|------|----------|-------------|
| 1 | `{nama_modul}` | `{fungsi}` | `{backend/frontend/both}` | `{P0}` | — |

**Priority:** P0 = MVP wajib, P1 = penting, P2 = nice to have

---

## 2. Module Detail

### {Nama Modul 1}

| Item | Detail |
|------|--------|
| Repo | `{backend / frontend / both}` |
| Route Prefix | `/{prefix}` (Backend: API route, Frontend: page route) |
| Middleware | `{auth, role:xxx}` |
| User Roles | `{role_yang_bisa_akses}` |

**Backend (jika ada):**

| Key Features | Key Models | Key Services |
|-------------|-----------|-------------|
| `{fitur_api}` | `{NamaModel}` | `{NamaService}` |

**Frontend (jika ada):**

| Key Pages | Key Components |
|-----------|---------------|
| `{halaman_index}` — `{fungsi}` | `{NamaKomponen}` |
| `{halaman_form}` — `{fungsi}` | `{NamaKomponen}` |

**External Dependencies:**
- `{API apa, package apa}`

---

### {Nama Modul 2}

| Item | Detail |
|------|--------|
| Repo | `{backend / frontend / both}` |
| Route Prefix | `/{prefix}` |

**Backend:** `{fitur}` | **Frontend:** `{halaman}`

---

## 3. Dependency Graph

```text
{deskripsi ketergantungan antar modul}

Modul A (BE) → Modul B (BE) — A depends on B's data
Modul A (FE) → Modul A (BE) — FE depends on BE API
Modul C (FE) → Modul A (BE) — lintas repo
```

---

## 4. Build Order

| Phase | Modul | Repo | Urutan | Alasan |
|-------|-------|------|--------|--------|
| 1 | `{auth, core}` | `{both}` | Paling dasar | Semua modul depend ke ini |
| 2 | `{modul_a}` | `{backend}` | Setelah core | |
| 3 | `{modul_a}` | `{frontend}` | Paralel dgn BE | FE bisa jalan paralel setelah API contract fix |
