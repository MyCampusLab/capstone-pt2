# TASK REPORT RULES — Laporan Task Wajib

> **Status:** PROCEDURE — AI WAJIB mengikuti aturan ini. JANGAN skip.
> **Purpose:** Setiap task yang selesai dan sudah di-push harus tercatat dalam laporan task.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Setiap Selesai Push/PR/Merge, WAJIB Buat Laporan

**PR/merge ke main** adalah milestone. Setiap kali AI:
- push ke `dev`
- merge ke `main`
- menyelesaikan satu fitur/bug fix yang berdiri sendiri

Maka **WAJIB** membuat laporan task.

### Struktur Folder

Laporan task disimpan di **root project** (bukan di dalam `dev-docs/`):

```text
{project-root}/
└── reports/
    ├── task/
    │   ├── backend/                           ← Laporan task backend
    │   │   └── YYYY-MM-DD-{nama-task}.md
    │   └── frontend/                          ← Laporan task frontend
    │       └── YYYY-MM-DD-{nama-task}.md
    └── maintenance/                           ← Laporan maintenance (jika MAINTENANCE_ACTIVE: true)
        └── {tahun}/
            ├── KAK/
            └── Laporan/
```

### Aturan Penamaan File

- Format: **`YYYY-MM-DD-{nama-task}.md`**
- `{nama-task}`: deskripsi singkat dengan tanda hubung (kebab-case)
- Contoh: `2026-04-17-add-menu-laporan-pembelajaran-digital.md`

### Aturan Pemisahan BE/FE

- Jika perubahan **hanya backend** → simpan di `reports/task/backend/`
- Jika perubahan **hanya frontend** → simpan di `reports/task/frontend/`
- Jika perubahan **mencakup BE dan FE** → buat **2 file terpisah** (masing-masing di folder `backend` dan `frontend`)

### Isi Minimal Laporan

Lihat template lengkap di `TASK_REPORT_TEMPLATE.md`. Isi minimal:

1. **Deskripsi Perubahan** — apa yang diubah, jelaskan dengan kalimat jelas
2. **Tujuan dan Manfaat** — kenapa perubahan ini dilakukan, apa dampaknya
3. **Daftar File yang Diubah** — list path lengkap
4. **Snapshot Kode (Before vs After)** — wajib! Jika before tidak tersedia, cukup after
5. **Verifikasi UAT** — checklist hasil test mandiri

### Aturan Penulisan

- Gunakan format **Markdown** (`.md`)
- Snapshot kode dalam code block ``````
- Before vs After diutamakan — gunakan `git diff` atau `git show` untuk mendapatkannya
- Jika before tidak tersedia (file baru), cukup sertakan after
- Setiap section diberi nomor (1, 2, 3, 4, 5)

### Timing

- Laporan dibuat **SETELAH push berhasil**, bukan ditunda ke sesi berikutnya
- Laporan dibuat **dalam batch kerja yang sama** dengan perubahan kode

### UAT Mandiri (Sebelum Push)

Sebelum membuat laporan task, AI WAJIB melakukan UAT mandiri:

1. Jalankan dev server: `php artisan serve --port=8000 &` (Laravel) atau `npm run dev &` (Node/Nuxt)
2. Test endpoint/feature via `curl` atau browser
3. Test minimal 2 skenario: **sukses** dan **gagal/edge case**
4. Verifikasi side-effect: log tercatat, data tersimpan, file terupdate
5. Matikan dev server: `kill $(lsof -ti :8000)`
6. Laporkan hasil UAT dalam tabel checklist ✅/❌

**Jika ada ❌ → STOP, perbaiki dulu, jangan push.**
