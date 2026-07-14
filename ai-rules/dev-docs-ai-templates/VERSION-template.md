# VERSION — Tracking & Rekomendasi Versi Rilis

> **Status:** GUIDANCE + DATA FILE — AI WAJIB membaca rules di bawah, tapi BOLEH mengisi data versi dan rekomendasi.
> **Purpose:** Single source of truth untuk versi aplikasi. AI menggunakan file ini untuk menentukan versi rilis berikutnya berdasarkan isi CHANGELOG.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Versi saat ini dan rekomendasi versi berikutnya berdasarkan analisis `[Unreleased]` di CHANGELOG.

### CRITICAL: Satu File untuk Semua Repo (Fullstack)

Untuk fullstack, backend dan frontend **bisa punya versi berbeda**. Gunakan format:

| Repo | Current Version |
|------|----------------|
| `backend` | `1.2.0` |
| `frontend` | `1.0.0` |

Untuk monolith, hanya 1 baris.

### Kapan AI WAJIB Mengisi Rekomendasi Versi?

| Trigger | Action |
|---------|--------|
| `[Unreleased]` di CHANGELOG sudah berisi entry signifikan | AI WAJIB membuat rekomendasi versi di file output `dev-docs/ai/VERSION.md` |
| Sebelum merge `dev` → `main` | AI WAJIB menentukan versi final dan menutup `[Unreleased]` |
| Saat milestone/sprint selesai | AI WAJIB review dan rekomendasikan versi |

### Prosedur Rilis Versi (AI Wajib Ikuti)

1. **Analisis** isi `[Unreleased]` di CHANGELOG
2. **Tentukan** versi berikutnya berdasarkan SemVer rules di bawah
3. **Tulis rekomendasi** di section "Next Version Recommendation" — sebutkan alasan
4. **Konfirmasi ke user** — tampilkan rekomendasi + alasan, minta approval
5. Setelah user approve:
   - **Update** Current Version ke versi baru
   - **Tutup** `[Unreleased]` di CHANGELOG → rename ke `[{versi_baru}]`
   - **Buat** section `[Unreleased]` baru untuk sprint berikutnya
   - **Update** `FINAL_SYSTEM_HANDOVER.md` dengan versi baru
   - **Tulis laporan task** di `reports/task/`

---

## Current Version

| Repo | Current Version | Release Date | Notes |
|------|----------------|-------------|-------|
| `{apps}` | `{0.1.0}` | `{YYYY-MM-DD}` | `{development / alpha / beta / stable}` |

> Untuk fullstack: ganti `{apps}` menjadi `{backend}` dan `{frontend}`.

---

## SemVer Decision Rules

Gunakan [Semantic Versioning 2.0.0](https://semver.org/): **MAJOR.MINOR.PATCH** (`1.2.3`)

### MAJOR (`X.0.0`) — Bump jika:

- **Breaking change** — API endpoint berubah signature, response format berubah, field dihapus/direname
- **Database** — migrasi yang tidak backward-compatible (drop kolom/tabel, rename kolom)
- **Auth** — perubahan mekanisme autentikasi (ganti JWT → session, ganti role structure)
- **Dependency** — upgrade framework versi mayor (Laravel 10 → 11, Nuxt 3 → 4)
- **Rilis stabil pertama** — dari `0.x.x` ke `1.0.0` saat aplikasi production-ready

### MINOR (`x.Y.0`) — Bump jika:

- **Fitur baru** — penambahan fitur yang backward-compatible (endpoint baru, halaman baru, modul baru)
- **Deprecation** — menandai fitur lama sebagai deprecated (tapi belum dihapus)
- **Significant enhancement** — refactor besar yang tidak mengubah behavior eksternal
- **New integration** — integrasi dengan third-party service baru

### PATCH (`x.y.Z`) — Bump jika:

- **Bug fix** — perbaikan bug yang backward-compatible
- **Security fix** — perbaikan celah keamanan
- **Performance** — optimisasi yang tidak mengubah behavior
- **Dependency patch** — upgrade patch/minor dependencies
- **Documentation** — perubahan docs only (opsional — bisa di-skip jika benar-benar hanya docs)
- **Minor UI fix** — typo, spacing, warna, alignment

### Rule Khusus Pra-1.0.0

Saat versi `0.x.x` (development/alpha/beta):

| Bump | Trigger |
|------|---------|
| `0.Y.0` | Fitur baru, breaking change, atau milestone signifikan |
| `0.y.Z` | Bug fix, patch, minor tweak |

**Tidak ada jaminan stabilitas API di `0.x.x`.**
`1.0.0` menandakan API stabil dan production-ready.

---

## How AI Determines Next Version

### Langkah 1: Baca `[Unreleased]` di CHANGELOG

Lihat kategori entry yang ada:
- `Added` → cenderung MINOR (atau MAJOR jika breaking)
- `Changed` → bisa MINOR atau MAJOR (tergantung backward-compatible)
- `Fixed` → PATCH
- `Deprecated` → MINOR
- `Removed` → MAJOR
- `Security` → PATCH (atau MINOR jika signifikan)

### Langkah 2: Pilih bump tertinggi

**Aturan:** Pilih versi berdasarkan entry dengan impact tertinggi.

| Ada Entry... | Versi Bump |
|--------------|-----------|
| `Removed` atau breaking `Changed` | **MAJOR** |
| `Added` atau `Deprecated` (tanpa breaking) | **MINOR** |
| Hanya `Fixed` + `Security` | **PATCH** |
| Hanya `Security` (critical) | **PATCH** |

### Langkah 3: Reset angka yang lebih kecil

- Bump MAJOR → MINOR dan PATCH reset ke 0
- Bump MINOR → PATCH reset ke 0
- Bump PATCH → hanya PATCH naik

### Langkah 4: Tulis alasan

Jelaskan kenapa versi tersebut dipilih, sebutkan entry changelog mana yang menentukan.

---

## Next Version Recommendation

> **Diisi AI sebelum rilis.** Analisis `[Unreleased]` di CHANGELOG, lalu isi di bawah.

### Rekomendasi Rilis

| Repo | Current | Recommended | Bump Type | Alasan |
|------|---------|-------------|-----------|--------|
| `{apps/backend/frontend}` | `{versi_saat_ini}` | `{versi_rekomendasi}` | `{MAJOR/MINOR/PATCH}` | `{deskripsi alasan — sebutkan entry CHANGELOG mana yang menentukan}` |

### Ringkasan Perubahan (dari CHANGELOG `[Unreleased]`)

```
{AI menyalin ringkasan singkat dari CHANGELOG [Unreleased] — ini membantu user memahami kenapa versi rekomendasi dipilih}
```

### Status Konfirmasi

| Status | User | Tanggal |
|--------|------|---------|
| `{Pending / Approved}` | `{nama_user}` | `{YYYY-MM-DD}` |

---

## Version History

| Date | Repo | Version | Type | Key Changes |
|------|------|---------|------|------------|
| `{YYYY-MM-DD}` | `{apps/backend/frontend}` | `{versi}` | `{MAJOR/MINOR/PATCH}` | `{ringkasan}` |

---

## Integration dengan File Lain

| File | Hubungan | Kapan Diupdate |
|------|---------|---------------|
| `../CHANGELOG.md` | Sumber input — `[Unreleased]` menentukan versi | Sebelum VERSION.md diisi |
| `FINAL_SYSTEM_HANDOVER.md` | Destination — versi terbaru dicatat di System Identity | Setelah versi di-release |
| `REPO_README_TEMPLATE.md` | Versi bisa dicantumkan di repo README | Saat rilis stabil |
| `../../planning/timeline.md` | Versi bisa direferensikan di milestone timeline | Saat milestone selesai |

---

## Template: Rekomendasi Versi (Copy untuk Rilis Baru)

```markdown
## Rekomendasi Rilis

| Repo | Current | Recommended | Bump Type | Alasan |
|------|---------|-------------|-----------|--------|
| {apps} | {versi_saat_ini} | {versi_rekomendasi} | {MAJOR/MINOR/PATCH} | {alasan} |

## Ringkasan Perubahan (dari CHANGELOG [Unreleased])

### Added
- {fitur_baru_1}
- {fitur_baru_2}

### Changed
- {perubahan_1}

### Fixed
- {bug_yang_difixed}

## Status Konfirmasi

| Status | User | Tanggal |
|--------|------|---------|
| Pending | — | — |
```
