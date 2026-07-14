# Dokumentasi Migration — Restrukturisasi Dokumentasi Existing ke ai-rules Format

> **Status:** GUIDANCE — Folder ini HANYA digunakan jika project sudah punya dokumentasi yang belum terstruktur, dan ingin migrasi ke struktur docs-ai.
> **Purpose:** Panduan AI untuk mengaudit, mengkategorikan, dan memigrasikan dokumentasi existing ke struktur output docs-ai.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output — JANGAN ubah template ini.

---

### Kapan Skenario Ini Digunakan

Skenario ini digunakan jika:

- Project sudah punya dokumentasi (README, wiki, Google Docs, Notion, Confluence, dll)
- Struktur dokumentasi belum mengikuti format docs-ai
- User ingin restrukturisasi ke struktur template docs-ai
- **BUKAN** untuk project baru dari nol (pakai Skenario 1: New Project)
- **BUKAN** untuk rewrite kode (pakai Skenario 2: Revamp)

### Perbedaan dengan Revamp

| Aspek | Revamp | Docs Migration |
|-------|--------|---------------|
| Yang di-migrasi | Kode + data | Dokumen |
| Old system | Kode existing (READ-ONLY) | Folder dokumen existing (READ-ONLY) |
| Output utama | Kode baru di apps/backend/frontend | File baru di planning/, dev-docs/, prod-docs/ |
| Folder output | revamp/ | dev-docs/ai/ (START_HERE.md + DOCS_MIGRATION_REPORT.md) |
| Kode aplikasi | Berubah total | Tidak disentuh |

---

### Posisi dalam Project Lifecycle

```
[Dokumen Existing]  ──migration/──▶  [planning/ + dev-docs/ + prod-docs/]
   (unstructured)       audit         (structured, template-aligned)
                              
[Old Docs]  ──▶  backup/old-docs/  ← tidak dihapus — disimpan sebagai referensi
```

---

### Struktur Folder Migration (AI OUTPUT, di project root)

| # | File Output | Purpose | Wajib? |
|---|-------------|---------|--------|
| 1 | `dev-docs/ai/DOCS_MIGRATION_REPORT.md` | Laporan audit + mapping + status migrasi | ✅ |
| 2 | `dev-docs/ai/START_HERE.md` | Dibuat/diupdate dari template — entry point setelah migrasi | ✅ |
| 3 | `backup/old-docs/` | Copy semua dokumen existing ke sini SEBELUM migrasi | ✅ |
| 4 | `planning/*` (jika contennya ada di old docs) | Dibuat dari template ai-rules/planning-templates/ | 🔶 Kondisional |
| 5 | `dev-docs/architecture/*` (jika contentnya ada di old docs) | Dibuat dari template ai-rules/architecture-templates/ | 🔶 Kondisional |
| 6 | `dev-docs/modules/` (jika contentnya ada di old docs) | Dibuat dari template ai-rules/modules-template/ | 🔶 Kondisional |
| 7 | `prod-docs/*` (jika contentnya ada di old docs) | Dibuat dari template ai-rules/prod-docs-templates/ | 🔶 Kondisional |

---

## Proses Migrasi (AI Wajib Ikuti)

### Step 1: Audit Dokumentasi Existing

**AI WAJIB melakukan audit menyeluruh:**

```bash
# Scan di mana dokumentasi existing berada
find . -name "*.md" -o -name "*.txt" -o -name "*.docx" -o -name "*.pdf" | grep -v node_modules | grep -v vendor | grep -v .git | grep -v backup

# List semua folder dokumentasi existing
ls -d docs/ wiki/ dokumentasi/ README* 2>/dev/null
```

**AI WAJIB membaca SEMUA file dokumentasi yang ditemukan**

Untuk setiap file, catat di `DOCS_MIGRATION_REPORT.md`:

| File | Tipe Konten | Relevan? | Target Folder Output |
|------|------------|----------|---------------------|
| `docs/README.md` | Overview project | ✅ | `dev-docs/ai/PROJECT_CONTEXT.md` |
| `docs/api.md` | API documentation | ✅ | `dev-docs/integrations/`, `dev-docs/modules/` |
| `wiki/setup.md` | Setup guide | 🔶 | Lihat mapping |
| `notion-page.txt` | Brain dump | ❌ | pending — perlu user clarify |

### Step 2: Backup Dokumentasi Existing

**SEBELUM mengubah apapun:**

```bash
mkdir -p backup/old-docs
cp -r docs/ wiki/ dokumentasi/ *.md backup/old-docs/ 2>/dev/null
```

Old docs = READ-ONLY. AI HANYA membaca. Output baru masuk ke folder output docs-ai.

### Step 3: Map Content ke Folder Output

Setelah membaca semua dokumen existing, AI membuat mapping:

Lihat `_DOCS_MAPPING_TEMPLATE.md` untuk panduan kategorisasi.

### Step 4: Ekstrak & Isi per Folder Output

Untuk SETIAP folder output, AI:

1. **BACA template** dari `ai-rules/{category}/`
2. **EKSTRAK info** dari old docs yang relevan
3. **ISI file output** di folder yang sesuai
4. **TAND AI** content yang tidak bisa dipastikan (butuh human clarify)

### Step 5: Verifikasi & Gap Report

Setelah semua file dibuat:

- [ ] Semua file output terisi MINIMAL (tidak ada file kosong)
- [ ] Semua konten penting dari old docs sudah ter-ekstrak
- [ ] Tidak ada konten dari old docs yang hilang
- [ ] Content yang ambigu/belum jelas → ditandai dengan `{⚠️ NEEDS CLARIFICATION: ...}`
- [ ] `START_HERE.md` sudah diisi dengan informasi hasil migrasi
- [ ] `DOCS_MIGRATION_REPORT.md` sudah lengkap (audit + mapping + status)

---

## Format: DOCS_MIGRATION_REPORT.md

Fil ini adalah laporan lengkap hasil migrasi. Lihat `_OLD_DOCS_AUDIT_TEMPLATE.md` untuk template detail.

### Section Structure

1. **Migration Metadata** — timestamp, AI model, scope
2. **Audit Summary** — jumlah file, tipe konten, kualitas
3. **Content Mapping** — tabel: file existing → target output
4. **Migration Status** — checklist per folder output
5. **Gaps & Ambiguities** — content yang butuh klarifikasi human
6. **Backup Info** — lokasi backup old docs

---

## Aturan

- **OLD DOCS = READ-ONLY** — AI hanya membaca, tidak mengubah/menghapus
- **AI TIDAK BOLEH membuat folder baru di dalam folder kode** — output tetap di project root
- **WAJIB backup sebelum migrasi** — `backup/old-docs/`
- **Jika konten ambigu:** tandai `{⚠️ NEEDS CLARIFICATION}` dan sebutkan di laporan
- **Jangan asumsi:** jika ada info yang tidak jelas di old docs, tanya user — jangan mengarang
- **Kredensial:** jika ada credential di old docs, mask di output (`***REDACTED***`) — kredensial hanya di `.env`
- **Prioritas folder yang WAJIB diisi:**
  1. `START_HERE.md` (entry point — dibuat/diupdate DULUAN)
  2. `PROJECT_CONTEXT.md` (system overview)
  3. `DOCS_MIGRATION_REPORT.md` (laporan migrasi)
  4. File output lainnya sesuai mapping

---

## Template Files

Lihat file template di folder ini:
- `_OLD_DOCS_AUDIT_TEMPLATE.md` — template untuk DOCS_MIGRATION_REPORT.md
- `_DOCS_MAPPING_TEMPLATE.md` — panduan kategorisasi konten old docs ke folder output
