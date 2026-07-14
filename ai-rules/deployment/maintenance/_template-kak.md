# Kerangka Acuan Kerja (KAK) — Maintenance {Project} Tahun {YYYY}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Template:** Isi oleh AI berdasarkan analisis kondisi existing project. Hapus placeholder `{...}` dan ganti dengan data aktual.

---

## Informasi Umum

| Item | Detail |
|------|--------|
| Nama Proyek | `{nama project}` |
| Tahun Anggaran | `{YYYY}` |
| Periode Pelaksanaan | `{bulan mulai}–{bulan selesai} {YYYY}` |
| Penanggung Jawab | `{nama}` |
| Status | Draft / Final |

---

## 1. Latar Belakang

**Jelaskan mengapa maintenance diperlukan tahun ini:**
- Kondisi aplikasi saat ini
- Masalah yang perlu diselesaikan
- Kebutuhan upgrade/migrasi

**Contoh untuk pemerintah:** "Sesuai anggaran murni {instansi} tahun {YYYY}, maintenance aplikasi {project} dilaksanakan untuk..."

---

## 2. Tujuan

- `{tujuan_1}`
- `{tujuan_2}`
- `{tujuan_3}`

---

## 3. Ruang Lingkup (Scope of Work)

### Scope A — Backup Production (Wajib)

| Item | Detail |
|------|--------|
| Target | Backup seluruh aplikasi dan database dari server production |
| Metode | Dump DB + gzip, zip aplikasi, download via SCP |
| Output | File backup tersimpan di lokal dan Google Drive |
| Verifikasi | File size, checksum, test restore |

### Scope B — {Nama Scope}

| Item | Detail |
|------|--------|
| Target | `{deskripsi}` |
| Metode | `{pendekatan teknis}` |
| Output | `{hasil yang diharapkan}` |

### Scope C — {Nama Scope}

| Item | Detail |
|------|--------|
| Target | `{deskripsi}` |
| Metode | `{pendekatan teknis}` |
| Output | `{hasil yang diharapkan}` |

---

## 4. Metodologi

**Pendekatan umum:**
- `{pendekatan — contoh: remote via SSH, eksekusi bertahap per server}`
- `{verifikasi setiap langkah sebelum lanjut}`

---

## 5. Timeline

| Scope | Bulan 1 | Bulan 2 | Bulan 3 | Bulan 4 |
|-------|---------|---------|---------|---------|
| A — Backup | █████ | | | |
| B — {scope} | | █████ | | |
| C — {scope} | | | █████ | |

---

## 6. Kriteria Keberhasilan

- [ ] `{kriteria_1}`
- [ ] `{kriteria_2}`
- [ ] `{kriteria_3}`

---

## 7. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi |
|--------|--------|----------|
| `{risiko}` | `{dampak}` | `{mitigasi}` |

---

## 8. Lampiran

- [backup-procedure.md](./backup-procedure.md) — SOP Backup
