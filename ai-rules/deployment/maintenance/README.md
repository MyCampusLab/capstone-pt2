# Maintenance Templates

> **Status:** TEMPLATE — Copy folder ini ke `{project-root}/reports/maintenance/{tahun}/` saat project memasuki masa maintenance.
> **Purpose:** Template KAK, laporan scope, dan SOP backup untuk proyek maintenance tahunan.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

Folder ini adalah template untuk maintenance tahunan. **HANYA digunakan saat `MAINTENANCE_ACTIVE: true`** di `deployment/ssh-access.md`.

### Alur Kerja Maintenance

1. **Cek `MAINTENANCE_ACTIVE`** — jika false, stop
2. **Baca KAK** dari `KAK/` — jika belum ada, AI wajib buat draft KAK
3. **Scope A (wajib): Backup production** — lihat [backup-procedure.md](./backup-procedure.md)
4. **Scope selanjutnya**: sesuai KAK — di-discover dari kondisi existing project
5. **Setiap scope selesai** → laporan di `Laporan/scope-{a,b,c,...}-{nama-scope}.md`
6. **Laporan utama** — gabungan semua scope

### Template Files

| File | Untuk | Kapan Dipakai |
|------|-------|-------------|
| `_template-kak.md` | Kerangka Acuan Kerja | Copy ke `KAK/kak-maintenance-{project}-{tahun}.md` |
| `_template-scope.md` | Laporan per scope | Copy untuk setiap scope: `scope-{a,b,c}-{nama-scope}.md` |
| `backup-procedure.md` | SOP backup production | Dibaca AI saat menjalankan Scope A |

### Aturan Penulisan Laporan (Penting!)

1. **DILARANG menyebut "AI Agent"** — gunakan "Tim Teknis" atau hilangkan
2. **DILARANG menyebut brand/merk perangkat** (MacBook, Dell, dll) — gunakan "komputer lokal", "workstation"
3. **DILARANG mencantumkan path lokal lengkap** — gunakan placeholder: `{path-project-lokal}`, `{path-backup-lokal}`
4. **DILARANG menyebut SSH config name / IP server** — gunakan istilah generik: "Akses ke server aplikasi"
5. **DILARANG menyertakan kode Mermaid** di laporan — export ke PNG, simpan di `assets/png/`
6. **Placeholder gambar** gunakan format:
   ```markdown
   <!-- Diagram: Judul Diagram -->
   <!-- ![Judul Diagram](assets/png/01-nama-file.png) -->
   ```
7. **Periode Pelaksanaan** harus sesuai kontrak/anggaran, bukan tanggal eksekusi aktual
