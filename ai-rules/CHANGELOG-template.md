# CHANGELOG

> **Status:** DATA FILE — AI WAJIB mencatat perubahan signifikan per milestone/sprint.
> **Purpose:** Log historis perubahan. File ini adalah **sumber input** untuk rekomendasi versi rilis di `dev-docs/ai/VERSION.md`.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Catatan kronologis perubahan signifikan. Satu entry per milestone/sprint/rilis besar. Setiap entry dikategorikan (Added/Changed/Fixed/Deprecated/Removed/Security) untuk mempermudah penentuan versi rilis.

###  CRITICAL: Hubungan dengan VERSION.md

CHANGELOG dan VERSION.md bekerja bersama:

| Step | File | Action |
|------|------|--------|
| 1 | **CHANGELOG** | AI mencatat perubahan di `[Unreleased]` setiap selesai task |
| 2 | **VERSION.md** | AI menganalisis `[Unreleased]` → rekomendasikan versi berikutnya |
| 3 | **User** | Approve rekomendasi versi |
| 4 | **CHANGELOG** | AI menutup `[Unreleased]` → rename ke `[{versi_baru}]` |
| 5 | **CHANGELOG** | AI membuat section `[Unreleased]` baru untuk sprint berikutnya |
| 6 | **VERSION.md** | AI update Current Version + Version History |

**AI WAJIB** mengisi rekomendasi versi di `VERSION.md` **sebelum** menutup `[Unreleased]`. Lihat `VERSION.md` untuk aturan SemVer lengkap (MAJOR.MINOR.PATCH).

###  CRITICAL: Anti-Monster Rule

JANGAN biarkan file ini tumbuh tanpa batas. Setelah satu tahun penuh, **arsipkan entry lama ke file terpisah**:

| File | Isi |
|------|-----|
| `CHANGELOG.md` | Hanya tahun berjalan (dan link ke arsip) |
| `CHANGELOG-{YYYY}.md` | Arsip per tahun |

Prosedur arsip:
1. Saat mulai tahun baru, rename `CHANGELOG.md` → `CHANGELOG-{tahun_sebelumnya}.md`
2. Buat `CHANGELOG.md` baru untuk tahun berjalan
3. Tambahkan link arsip di bagian bawah file baru

**When to update:**
- Setiap selesai task → tambahkan entry di `[Unreleased]`
- Setiap selesai milestone/sprint → rekomendasikan versi di `VERSION.md`
- Sebelum merge `dev` → `main` → tutup `[Unreleased]` dengan versi final
- Setiap kali ada rilis/deploy ke production

**Format per entry:**
- Added: fitur baru → trigger MINOR
- Changed: perubahan fitur yang sudah ada → bisa MINOR atau MAJOR (jika breaking)
- Fixed: bug fix → trigger PATCH
- Deprecated: fitur yang akan dihapus → trigger MINOR
- Removed: fitur yang dihapus → trigger MAJOR
- Security: perbaikan keamanan → trigger PATCH

---

## [Unreleased] — Current Sprint/Milestone

### Added
- `{fitur_baru}`

### Changed
- `{perubahan}`

### Fixed
- `{bug_yang_difixed}`

---

## [{versi}] — {YYYY-MM-DD}

### Added
- `{fitur_baru}`

### Changed
- `{perubahan}`

### Fixed
- `{bug_yang_difixed}`

### Deprecated
- `{fitur_yang_akan_dihapus}`

### Removed
- `{fitur_yang_dihapus}`

### Security
- `{perbaikan_keamanan}`

---

## Template Entry (Copy for New Release)

```markdown
## [{versi}] — {YYYY-MM-DD}

### Added
- 

### Changed
- 

### Fixed
- 

### Removed
- 

### Security
- 
```

---

## Archived Changelogs

- `CHANGELOG-{2026}.md` ← Rename & arsip saat ganti tahun
