# START_HERE

> **Status:** GUIDANCE + DATA FILE — AI mengisi data project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Titik masuk pertama untuk AI agent. Dibaca pertama kali saat onboarding.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Ini adalah halaman onboarding untuk AI agent baru. Setelah menganalisis repository, AI WAJIB mengBUAT section di bawah ini di FILE OUTPUT (bukan di template ini):
1. **Best reading order** — urutan baca file dokumentasi agar agent baru paham project secepat mungkin
2. **Repository quick facts** — fakta penting dalam format tabel
3. **High-priority current work** — apa yang sedang dikerjakan sekarang
4. **Safety notes** — hal-hal yang harus dihindari

###  Onboarding Mode: Project Baru vs Adopsi

**Lihat apakah `planning/`, `revamp/`, dan `planning/PROJECT_BRIEF.md` ada di root project.**

| Kondisi | Mode | Yang Dilakukan AI |
|---------|------|------------------|
| `planning/` ada tapi kosong, tidak ada `PROJECT_BRIEF.md` | **New (Interaktif)** | AI WAJIB bertanya ke user (lihat Mode B di bawah) |
| `planning/PROJECT_BRIEF.md` sudah terisi | **New via Brief** | Baca brief → isi planning + dev-docs/ai → mulai coding |
| `planning/` terisi + `revamp/` ada | **Revamp** | Baca planning + revamp docs dulu, baru mulai coding |
| Hanya `dev-docs/` ada | **Adopsi** | AI WAJIB lakukan onboarding analysis 10-step |

### Mode A: New via PROJECT_BRIEF (Brief sudah ada)

Jika `planning/PROJECT_BRIEF.md` sudah terisi (user mengisi manual), AI WAJIB:

1. **Baca `planning/PROJECT_BRIEF.md`**
2. **Isi semua `planning/*.md`** + **`dev-docs/ai/*.md`** berdasarkan brief
3. **Konfirmasi ke user** — tampilkan ringkasan, minta approval
4. **Mulai coding** setelah approve

### Mode B: New Interaktif (Brief belum ada — AI WAJIB bertanya!)

Jika `planning/` ada, file planning masih template kosong, dan **tidak ada `PROJECT_BRIEF.md`**, AI WAJIB:

1. **Deteksi:** Tidak ada brief. Jangan langsung isi planning — tanya dulu.
2. **Ajukan pertanyaan interaktif** satu per satu berdasarkan template brief (13 section). Mulai dari yang paling penting:
   - **Vision:** "Apa produk ini? Untuk siapa? Masalah apa yang diselesaikan? Ada pain points spesifik?"
   - **Tech Stack:** "Monolith atau fullstack? Framework BE? Framework FE? DB? Cache/queue/storage?"
   - **MVP Features:** "Fitur apa saja yang HARUS ada di rilis pertama? Sebutkan semua."
   - **Non-Goals:** "Apa yang TIDAK dibangun di Phase 1? (Ini penting untuk cegah scope creep)"
   - **User Roles & Permissions:** "Siapa user-nya? Role apa saja? Level aksesnya?"
   - **Business Rules:** "Ada aturan bisnis yang harus di-enforce sistem? (Format JIKA...MAKA...)"
   - **Key Workflows:** "Ada flow utama? Bisa deskripsikan langkah-langkahnya?"
   - **Integrations:** "Ada koneksi ke layanan eksternal? API pihak ketiga?"
   - **Architecture Decisions:** "Ada keputusan arsitektur yang sudah dipikirkan? (contoh: provider-agnostic, modular monolith)"
   - **Success Criteria:** "Bagaimana kita tahu project ini sukses? Metrik apa yang diukur?"
   - **Timeline & Constraints:** "Target rilis? Estimasi user? Budget constraints?"
   - **Final Goal:** "Apa north star / tujuan akhir project ini?"
3. **Jangan tanya semua sekaligus** — 2-3 pertanyaan per round, tunggu jawaban user, baru lanjut
4. **Tulis `planning/PROJECT_BRIEF.md`** dari jawaban user — lengkap 13 section
5. **Lanjutkan** ke Mode A — isi semua planning + dev-docs/ai dari brief yang baru dibuat
6. **Konfirmasi ke user** — tampilkan ringkasan planning yang sudah diisi, minta approval

AI **TIDAK BOLEH** langsung mengisi planning tanpa brief atau tanpa bertanya.
AI **BOLEH** mengimprovisasi detail teknis saat mengisi planning dari brief — brief adalah arahan, planning adalah elaborasi.

### Mode Adopsi: Onboarding Analysis (Wajib!)

Jika project ini adalah project existing yang baru di-adopsi ke vibe coding (tidak ada `planning/`, tidak ada `revamp/`), AI WAJIB melakukan onboarding analysis SEBELUM menulis kode apapun:

1. **Baca seluruh codebase** — pahami struktur direktori, entry point, routing, middleware
2. **Isi `PROJECT_CONTEXT.md`** — deklarasi project type (monolith/fullstack), stack, database topology, source structure
3. **Isi `PROJECT_MENTAL_MODEL.md`** — pola arsitektur, request execution, UI pattern, risk hotspots
4. **Isi `MODULE_MAP.md`** — mapping setiap modul ke file kode aktual
5. **Isi semua file `architecture/`** — api-flow, backend-structure, frontend-structure, database
6. **Isi `CODING_RULES.md`** — ekstrak konvensi coding dari kode yang SUDAH ada
7. **Isi `CURRENT_STATE.md`** — snapshot kondisi existing: module maturity, QA state
8. **Isi `TECHNICAL_DEBT.md`** — code smell yang ditemukan, risky areas
9. **Buat folder `modules/{modul}/`** — dokumentasikan setiap modul dengan struktur split-per-concern
10. **Isi `AGENTS.md`** — aturan coding spesifik project, branch policy

Setelah onboarding selesai, AI baru boleh mulai coding task.

**When to update:**
- Pertama kali setup project (new atau adopsi)
- Saat ada modul besar baru
- Saat ada perubahan arsitektur fundamental
- Saat pivot produk

---

## Quick Facts

| Item | Value |
|------|-------|
| Repository | `{nama_repository}` |
| Project Type | `{Monolith / Fullstack}` |
| Git Location | `{apps/ | backend/ + frontend/}` |
| Stack | `{backend_framework} + {frontend_framework}` |
| DB | `{database_type}` |
| Branch dev | `{nama_branch_dev}` |
| Branch main | `main` |
| Testing | `{test_framework}` |

---

## Recommended Reading Order

Untuk memahami codebase ini, baca dengan urutan:

1. `PROJECT_CONTEXT.md` — Overview sistem dan stack
2. `PROJECT_MENTAL_MODEL.md` — Cara berpikir tentang codebase ini
3. `MODULE_MAP.md` — Mapping modul ke kode
4. `../architecture/api-flow.md` — Flow request
5. `../architecture/backend-structure.md` — Struktur backend
6. `../architecture/database.md` — Arsitektur database
7. `../architecture/frontend-structure.md` — Struktur frontend
8. `CURRENT_STATE.md` — Kondisi terkini development
9. `TASKS.md` — Task aktif dan prioritas
10. `KNOWN_ISSUES.md` — Issue yang diketahui
11. `TECHNICAL_DEBT.md` — Utang teknis
12. `VERSION.md` — Versi saat ini dan rekomendasi versi rilis
13. `../deployment/git-remote.md` — Repository access dan deploy setup
14. `../decisions/` — ADR untuk keputusan arsitektur
15. `../modules/` — Dokumentasi per modul

---

## High-Priority Current Work

**Deskripsikan di sini — AI saat onboarding akan mengisi:**

- `{prioritas_1}` — `{deskripsi singkat}`
- `{prioritas_2}` — `{deskripsi singkat}`
- `{prioritas_3}` — `{deskripsi singkat}`

---

## Safety Notes for Agents

**Isi oleh AI setelah analisis risiko codebase:**

- `{catatan_keamanan_1}`
- `{catatan_keamanan_2}`
- `{catatan_keamanan_3}`
