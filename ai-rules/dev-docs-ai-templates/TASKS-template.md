# TASKS

> **Status:** DATA FILE — AI WAJIB mengupdate setiap task baru/selesai.
> **Purpose:** Daftar task aktif, prioritas, dan "definition of done" untuk milestone saat ini.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Tracking board untuk semua task development.

###  CRITICAL: Anti-Monster Rule

**DILARANG** menumpuk task history di file ini. Hanya task **aktif** yang dicatat di sini. Task yang sudah **Done >1 minggu** → pindahkan ke arsip.

| File | Isi |
|------|-----|
| `TASKS.md` | Hanya task aktif (Todo, In Progress, Blocked, Done <1 minggu) |
| `TASKS-ARCHIVE.md` | Task yang sudah Done — referensi historis |

**Pindahkan ke arsip:** setelah task Done dan kondisi stabil >1 minggu.

**Priority definitions:**
- **P0:** Critical — harus diselesaikan sebelum merge ke main
- **P1:** High — harus diselesaikan dalam milestone ini
- **P2:** Medium — bagus diselesaikan
- **P3:** Low — nice to have

**Status definitions:**
- **Todo:** Belum dimulai
- **In Progress:** Sedang dikerjakan
- **Blocked:** Terhambat dependency
- **Done:** Selesai (pindahkan ke arsip setelah 1 minggu)

---

## Active Tasks

| Priority | ID | Status | Task | Notes |
|----------|----|--------|------|-------|
| `{P0}` | `{TASK-001}` | `{status}` | `{deskripsi task}` | `{catatan / blocker}` |

---

## Recently Done (<1 week)

| ID | Task | Completion Date | Notes |
|----|------|----------------|-------|
| `{TASK-XXX}` | `{deskripsi}` | `{YYYY-MM-DD}` | `{catatan}` |

---

## Inferred Next Tasks (from Repository Analysis)

| Priority | Task | Reason |
|----------|------|--------|
| `{P1}` | `{deskripsi}` | `{alasan — berdasarkan analisis kode}` |

---

## Definition of Done for Current Milestone

- `{kriteria_1}`
- `{kriteria_2}`

**Milestone:** `{nama_milestone}`

---

## Archive

Lihat [TASKS-ARCHIVE.md](./TASKS-ARCHIVE.md) untuk task yang sudah selesai.
