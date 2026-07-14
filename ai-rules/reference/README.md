# reference/ — User Knowledge Artifacts

> **Status:** DATA DIRECTORY — Folder ini berisi file dari user/stakeholder sebagai acuan development. JANGAN diubah AI.
> **Purpose:** Primary source knowledge — database Excel user, SOP perusahaan, dokumen instrumen, form manual, dan artifact lain dari dunia nyata yang akan ditransformasi menjadi sistem.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Read-Only Primary Sources

**DILARANG KERAS mengubah file di folder ini.** File di sini adalah artifact asli dari user — primary source of truth untuk development. AI hanya boleh **membaca**, bukan mengubah.

Jika ada data/struktur yang perlu di-update, minta user untuk memberikan file baru atau minta izin eksplisit.

### Bedanya dengan folder lain

| Aspek | `temp/` | `reference/` |
|-------|---------|-------------|
| Sumber | AI (hasil analisis sendiri) | User / stakeholder |
| Sifat | Sementara, dibuang setelah task | Permanen, acuan development |
| Contoh isi | Draft rencana, log debug | DB Excel user, SOP, form manual |
| Yang menulis | AI | Human (drop file) |
| AI boleh ubah? | Boleh | **Tidak boleh** |
| Nasib di `main` | Di-exclude | Tetap di `dev` |

---

## What Goes Here

| Kategori | Contoh File | Untuk Apa |
|----------|-----------|----------|
| **Data Source** | `data-pegawai.xlsx`, `daftar-wajib-pajak.csv` | Acuan struktur database & migrasi data |
| **SOP / Aturan Bisnis** | `sop-pengadaan-2025.pdf`, `alur-persetujuan.docx` | Acuan workflow & business logic |
| **Form Manual** | `form-pendaftaran.pdf`, `surat-keputusan.docx` | Acuan desain form input & output |
| **Dokumen Instrumen** | `instrumen-audit-2026.xlsx`, `kuesioner-evaluasi.pdf` | Acuan fitur audit/evaluasi |
| **Laporan Existing** | `laporan-bulanan-template.xlsx` | Acuan format output/export |
| **Regulasi** | `perda-no-5-2024.pdf`, `permen-keu-2025.pdf` | Acuan compliance & aturan bisnis |
| **Aset / Branding** | `logo.png`, `style-guide.pdf` | Acuan UI/UX |

---

## Cara Organisasi

Buat subfolder per kategori agar rapi:

```
reference/
├── README.md                    ← File ini
├── data-sources/                ← Excel, CSV, database dump dari user
├── sop-dan-aturan/              ← SOP, workflow, aturan bisnis
├── form-dan-dokumen/            ← Form manual, surat, template dokumen
├── instrumen/                   ← Kuesioner, instrumen audit/evaluasi
├── regulasi/                    ← Perda, permen, aturan hukum
├── branding/                    ← Logo, style guide, font
├── laporan-template/            ← Template laporan dari user
└── template/                    ← HTML template UI (Metronic, AdminLTE, dll)
    ├── metronic-8/              ← Contoh: Metronic 8 template
    │   ├── README.md            ← Dokumentasi template (struktur, komponen, cara pakai)
    │   ├── dist/                ← Compiled assets (CSS, JS)
    │   ├── src/                 ← Source HTML templates
    │   └── docs/                ← Dokumentasi resmi dari vendor
    └── adminlte-3/              ← Contoh: AdminLTE 3 template
        └── ...
```

### 📁 Subfolder `template/` — HTML Template untuk UI

**WAJIB ada jika user menyediakan HTML template** (lihat `planning/PROJECT_BRIEF.md` section "UI/UX Template & Design System").

**Isi folder ini:**
- HTML template lengkap dari vendor (Metronic, AdminLTE, Stisla, dll)
- Dokumentasi template (README.md yang menjelaskan struktur, komponen available, cara customize)
- Source files (HTML, CSS, JS, assets)
- Contoh implementasi komponen (jika ada)

**Aturan AI saat menggunakan template:**
1. **BACA** `template/{nama}/README.md` sebelum mulai membuat UI
2. **GUNAKAN** komponen yang sudah ada di template (jangan buat ulang)
3. **IKUTI** struktur HTML dan naming convention dari template
4. **CUSTOMIZE** hanya jika fitur yang dibutuhkan tidak tersedia di template
5. **DOKUMENTASIKAN** komponen template mana yang dipakai di `dev-docs/modules/{modul}/views.md`

---

## Aturan AI Saat Membaca File Ini

1. **BACA** semua file di folder ini sebelum mulai mengerjakan modul terkait
2. **JANGAN UBAH** file apapun — ini artifact asli user
3. **GUNAKAN** sebagai acuan: struktur database dari Excel, workflow dari SOP, layout form dari form manual
4. **KONFIRMASI** ke user jika ada ambiguitas atau data yang tampak tidak konsisten
5. **DOKUMENTASIKAN** mapping dari reference → implementasi di `dev-docs/modules/{modul}/README.md` — sebutkan file reference mana yang jadi acuan

---

## Mapping Reference → Implementasi

**AI wajib mencatat jejak:** dari file reference mana → jadi fitur/modul apa. Ini penting untuk traceability.

Contoh:
- `data-sources/data-pegawai.xlsx` → `modules/kepegawaian/database.md` (struktur tabel)
- `sop-dan-aturan/sop-pengadaan.pdf` → `modules/pengadaan/services.md` (business logic)
- `form-dan-dokumen/form-pendaftaran.pdf` → `modules/pendaftaran/views.md` (desain form)
