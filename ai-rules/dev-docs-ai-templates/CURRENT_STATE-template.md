# CURRENT_STATE

> **Status:** DATA FILE — AI WAJIB mengupdate setiap akhir task. Ini adalah snapshot kondisi development terkini.
> **Purpose:** Single source of truth untuk tahu "apa yang sedang terjadi sekarang" di project.
> **Related:** [TASKS.md](./TASKS.md) (task aktif) · [CHANGELOG.md](../CHANGELOG.md) (log kronologis) · [VERSION.md](./VERSION.md) (versi rilis)

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Update setiap selesai task/batch. Ini adalah "dashboard" kondisi project saat ini.

###  Dual-Repo: Snapshot Per Repo

**Lihat deklarasi project type di `PROJECT_CONTEXT.md`.**

- **Monolith** → 1 baris snapshot di tabel Snapshot
- **Fullstack** → 1 baris per repo (backend + frontend) + commit hash masing-masing

Untuk fullstack, module maturity juga butuh kolom extra: module mana di backend, mana di frontend.

**When to update:** SETIAP akhir task — wajib.

---

## Snapshot

| Repo | Branch | Last Commit | Notes |
|------|--------|------------|-------|
| `{apps — monolith} / {backend — fullstack} / {frontend — fullstack}` | `{dev}` | `{hash}` | `{catatan}` |

| Last Updated | `{YYYY-MM-DD}` |
| Updated By | `{nama_model_AI}` |

---

## Recent Development Highlights

| Repo | Commit | Date | Summary |
|------|--------|------|---------|
| `{apps/backend/frontend}` | `{hash}` | `{tanggal}` | `{ringkasan}` |

---

## Module Maturity (Practical State)

| Module | Repo | State | Notes |
|--------|------|-------|-------|
| `{nama_modul}` | `{backend / frontend / apps}` | `{Planned / In Progress / Beta / Production / Deprecated}` | `{catatan}` |

**State definitions:**
- **Planned:** Belum ada kode, baru rencana
- **In Progress:** Kode ada, masih aktif dikembangkan
- **Beta:** Kode ada, fitur lengkap, belum production-ready
- **Production:** Stabil, digunakan di production
- **Deprecated:** Akan dihapus/diganti

---

## Active Backlog (Non-Done Tasks)

| Priority | ID | Status | Task | Repo | Notes |
|----------|----|--------|------|------|-------|
| `{P0/P1/P2/P3}` | `{TASK-001}` | `{Todo / In Progress / Blocked}` | `{deskripsi}` | `{backend/frontend}` | `{catatan}` |

---

## Test / QA State

| Repo | Area | Coverage | Status |
|------|------|----------|--------|
| `{apps/backend}` | `{unit_test}` | `{estimasi %}` | `{Passing / Failing / Not Run}` |
| `{apps/backend}` | `{lint}` | — | `{Passing / Failing / Not Run}` |
| `{frontend}` | `{lint}` | — | `{Passing / Failing / Not Run}` |
| `{frontend}` | `{build}` | — | `{Passing / Failing}` |

---

## Important Nuance

**Isi dengan hal-hal yang tidak obvious tapi penting diketahui:**
- Assumption based on repository analysis: `{asumsi}`
- `{catatan_penting_lainnya}`
