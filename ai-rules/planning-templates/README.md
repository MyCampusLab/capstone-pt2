# Planning Docs — Cetak Biru Project

> **Status:** GUIDANCE — Folder ini berisi dokumen perencanaan. Dibuat sebelum development dimulai, jarang diubah.
> **Bedanya dengan `dev-docs/`:** `planning/` adalah **cetak biru** (apa yang akan dibangun), `dev-docs/` adalah **dokumentasi berjalan** (apa yang sedang/terjadi dibangun).

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**Purpose:** Dokumen di folder ini adalah "source of truth" untuk **apa yang akan dibangun**. AI agent WAJIB membaca folder ini sebelum mulai coding. Setiap keputusan desain harus merujuk ke dokumen planning, bukan improvisasi.

**Bedanya dengan dev-docs:**

| Aspek | `planning/` | `dev-docs/` |
|-------|-----------|-----------|
| Fase | Sebelum development | Selama/setelah development |
| Yang membuat | Human (dengan asistensi AI) | AI (setiap selesai task) |
| Frekuensi update | Jarang — hanya saat scope berubah | Sering — setiap task |
| Isi | Apa yang akan dibangun | Apa yang sudah/terjadi dibangun |
| Status | Cetak biru | Living documentation |

**Kapan folder ini dibuat:**
- Project baru dari nol
- Fitur besar yang perlu spesifikasi sebelum coding
- Re-architect / rewrite

**Kapan folder ini TIDAK perlu:**
- Bug fix kecil / hotfix
- Project yang sudah mature dan jelas arahnya

---

## File Index

| # | File | Purpose | Wajib? |
|---|------|---------|--------|
| 1 | `prd.md` | Product Requirements Document — visi produk, user stories, fitur | ✅ Wajib |
| 2 | `architecture.md` | Tech stack, system design, komponen utama | ✅ Wajib |
| 3 | `database.md` | ERD, schema plan, relasi | ✅ Wajib (jika ada DB) |
| 4 | `modules.md` | Breakdown modul/fitur, dependency antar modul | ✅ Wajib |
| 5 | `api-contract.md` | Kontrak API antara frontend dan backend | Fullstack only |
| 6 | `wireframe.md` | Rencana UI/UX, layout halaman, flow pengguna | Jika ada UI |
| 7 | `timeline.md` | Milestone, estimasi, prioritas rilis | ✅ Wajib |

**Aturan:**
- File yang tidak relevan TIDAK perlu dibuat (contoh: `api-contract.md` untuk monolith Laravel + Blade)
- AI BOLEH membaca semua file planning sebelum coding
- AI TIDAK BOLEH mengubah file planning tanpa izin user — ini cetak biru, bukan living doc
