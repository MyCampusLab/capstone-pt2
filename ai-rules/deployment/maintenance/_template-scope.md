# Laporan Scope {A/B/C/...} — {Nama Scope}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Template:** Copy untuk setiap scope maintenance. Isi oleh AI setelah scope selesai dikerjakan.
> **Nama file:** `scope-{a,b,c}-{nama-scope}.md`

---

## Metadata Dokumen

| Item | Detail |
|------|--------|
| Kode Scope | `{A / B / C / ...}` |
| Nama Scope | `{nama scope}` |
| Tanggal Pelaksanaan | `{YYYY-MM-DD}` |
| Periode Maintenance | `{bulan mulai}–{bulan selesai} {YYYY}` |
| Acuan KAK | `kak-maintenance-{project}-{tahun}.md` |
| Status | Belum Dimulai / Dalam Pelaksanaan / Selesai |
| Penanggung Jawab | `{nama}` |

---

## 1. Deskripsi Perubahan

### Latar Belakang

`{jelaskan kenapa scope ini diperlukan}`

### Ruang Lingkup

- `{item_1}`
- `{item_2}`

### Target Outcome

- `{outcome_1}`
- `{outcome_2}`

---

## 2. Tujuan dan Manfaat

### Tujuan Teknis
- `{tujuan_teknis_1}`
- `{tujuan_teknis_2}`

### Manfaat Operasional
- `{manfaat_ops_1}`
- `{manfaat_ops_2}`

### Manfaat Strategis
- `{manfaat_strategis_1}`

---

## 3. Metode Eksekusi

### Pendekatan Teknis

`{pendekatan — remote SSH, script, manual, dll}`

### Langkah Eksekusi

1. **`{langkah_1}`**
   ```bash
   {command}
   ```

2. **`{langkah_2}`**
   ```bash
   {command}
   ```

### Metode Verifikasi

- `{cara verifikasi langkah berhasil}`

---

## 4. Snapshot / Log Teknis (Wajib)

### Before
```
{output sebelum — versi, status service, config, file size, dll}
```

### After
```
{output sesudah — versi, status service, config, file size, dll}
```

### Output Command Penting
```
{salin output command yang relevan}
```

---

## 5. Diagram / Alur / Proses (Wajib)

<!-- Diagram: Alur {Nama Scope} -->
<!-- ![{Nama Scope}](assets/png/{number}-{nama-diagram}.png) -->

---

## 6. Verifikasi dan Validasi

| # | Item Verifikasi | Status | Notes |
|---|----------------|--------|-------|
| 1 | `{item}` | ✅ / ❌ | `{catatan}` |
| 2 | `{item}` | ✅ / ❌ | `{catatan}` |

---

## 7. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi | Status |
|--------|--------|----------|--------|
| `{risiko}` | `{dampak}` | `{mitigasi}` | Teratasi / Terjadi |

---

## 8. Rollback Plan

**Jika scope ini gagal, langkah rollback:**
1. `{langkah_rollback_1}`
2. `{langkah_rollback_2}`

---

## 9. Evidence / Bukti Kerja

### Screenshot (opsional)

### Log Output

```
{salin output command / log sebagai bukti}
```

### Bukti Command Berhasil

```
{output exit code 0 / success message}
```
