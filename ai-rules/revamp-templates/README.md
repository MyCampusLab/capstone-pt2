# Revamp Plan — Migrasi dari Old System ke New System

> **Status:** GUIDANCE — Folder ini HANYA dibuat jika project adalah revamp/migrasi dari sistem lama ke baru.
> **Purpose:** Dokumentasi analisis project lama dan rencana transisi ke arsitektur baru.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  Kapan Folder Ini Dibuat

Folder `revamp/` HANYA untuk skenario:
- Migrasi dari monolith → fullstack (1 old → 1 new)
- Rewrite dari framework lama → framework baru
- Re-architect dari legacy → modern stack
- **Merger/konsolidasi:** beberapa sistem terpisah → 1 platform (N apps → 1 app)

**Jika project baru dari nol**, folder ini TIDAK perlu. Gunakan `planning/` saja.

### Dua Sub-Skenario

| Skenario | Deskripsi | File Utama |
|----------|----------|-----------|
| **Revamp 1:1** | 1 old system di-rewrite ke 1 new system | `old-system.md` + `gap-analysis.md` + `migration-strategy.md` |
| **Merger N:1** | Beberapa aplikasi terpisah digabung ke 1 aplikasi utama | `merger-plan.md` (gantikan `old-system.md`) |

**Catatan Revamp 1:1:** New system bisa tetap monolith (1 repo `apps/`) atau jadi fullstack (2 repo `backend/` + `frontend/`). Contoh: Laravel monolith → Goravel backend + React frontend. Template ini mengakomodir keduanya — AI akan menyesuaikan berdasarkan `planning/architecture.md`.

### Posisi dalam Project Lifecycle

```
Revamp 1:1:
[Old System]  ──revamp/──▶  [planning/]  ──▶  [dev-docs/]  ──▶  [New System]
   (existing)    analisis     (cetak biru)       (living)       (kode baru)

Merger N:1:
[App A] ──┐
[App B] ──┤
[App C] ──┼──revamp/──▶ [planning/] ──▶ [dev-docs/] ──▶ [App A' — sudah gabung]
[App N] ──┘   merger        (cetak biru)     (living)       (hanya A yg dipertahankan)
```

### Struktur Folder

| # | File | Purpose | Skenario | Wajib? |
|---|------|---------|---------|--------|
| 1 | `old-system.md` | Audit sistem lama — fitur, DB, arsitektur, pain points | Revamp 1:1 | ✅ (untuk revamp) |
| 2 | `gap-analysis.md` | Gap: apa yang berubah, apa yang di-improve dari old ke new | Revamp 1:1 | ✅ (untuk revamp) |
| 3 | `migration-strategy.md` | Strategi: paralel, big-bang, phased, rollback plan | Revamp 1:1 | ✅ (untuk revamp) |
| 4 | `data-migration.md` | Rencana migrasi data: mapping schema, script, verifikasi | Keduanya | ✅ (jika ada DB) |
| 5 | `merger-plan.md` | **Merger N:1** — audit multi apps + overlap analysis + strategi gabung | Merger only | ✅ (untuk merger) |

### Aturan

- AI WAJIB membaca `old-system.md` sebelum menyentuh kode baru — pahami apa yang sudah ada
- AI WAJIB membaca `migration-strategy.md` sebelum deploy — jangan sampai old system broken
- Folder `apps/` (old system monolith) bersifat **READ-ONLY** — AI hanya membaca, tidak mengubah
- Semua kode baru ditulis di `backend/` + `frontend/`
- Old system hanya disentuh saat eksekusi data migration (itupun dengan izin eksplisit)
