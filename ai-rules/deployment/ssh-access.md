# SSH Access & DevOps Rules

> **Status:** DATA FILE — HANYA dibuat jika project membutuhkan akses server via SSH. Jika tidak ada server, file ini TIDAK perlu dibuat.
> **Purpose:** Aturan akses SSH dari local ke server production. **File ini mengatur "AI masuk ke server"** — bukan "server ambil kode dari git".
> **Beda dengan git-remote.md:** `ssh-access.md` = local → server. `git-remote.md` = server → git repo. Keduanya bisa ada secara independen.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Isi hanya jika project ini memiliki server production yang bisa diakses via SSH dari local.

**When this file exists:**
- AI BOLEH mengakses server sesuai aturan di bawah
- AI WAJIB mematuhi semua batasan yang tertulis

**When this file does NOT exist:**
- AI TIDAK BOLEH mengakses server manapun
- Semua kerja development hanya di local

---

##  CRITICAL: SSH Context

SSH config terdaftar di `~/.ssh/config` local MacBook. AI bisa mengakses server langsung dengan perintah `ssh <config-name>`.

**Semua perubahan kode aplikasi TETAP dilakukan di local.** Server production hanya menjalankan `git pull` — AI tidak boleh mengedit file kode langsung di server. Jika ditemukan bug di server, perbaiki di local → commit & push → server pull.

---

## Maintenance Mode

```yaml
MAINTENANCE_ACTIVE: false  # Set false jika masa maintenance sudah selesai
MAINTENANCE_YEAR: 2026
```

**Aturan Maintenance:**
1. Semua scope dan aturan maintenance berlaku **selama `MAINTENANCE_ACTIVE: true`**.
2. Jika `MAINTENANCE_ACTIVE: false`, AI **tidak boleh** mengakses server atau menjalankan scope maintenance, **kecuali** user meminta secara eksplisit.
3. Setiap tahun maintenance memiliki scope yang berbeda tergantung kondisi infrastruktur.

---

## Server Registry

> **SECURITY:** File ini berada di `ai-rules/` (IMMUTABLE template). Output akan dibuat di `prod-docs/` (DI LUAR git repo). IP dan credential BOLEH di prod-docs/ karena tidak di-push ke GitHub. Tapi DILARANG menulis IP/credential di file .md di dalam folder kode (`apps/`, `backend/`, `frontend/`).

| SSH Config | Server | Purpose | Detail Location |
|-----------|--------|---------|----------------|
| `{ssh-config-name}` | `{deskripsi server}` | `{aplikasi / database / keduanya}` | See prod-docs/docs/architecture/overview.md |

---

## Access Rules

### Kapan AI Boleh Akses Server

- `{kondisi — contoh: "Selama MAINTENANCE_ACTIVE: true" atau "Hanya jika user meminta secara eksplisit"}`

### Larangan Keras

1. **DILARANG** mengubah password database di server manapun.
2. **DILARANG** mengedit file kode langsung di server — semua perubahan via local → git push → server pull.
3. **DILARANG** menghapus file/data tanpa konfirmasi user.
4. **DILARANG** menyebutkan SSH config name, IP, atau credential server di file .md yang ada DI DALAM folder kode (`apps/`, `backend/`, `frontend/`). BOLEH di folder documentation di project root (`prod-docs/`, `dev-docs/`, `reports/`) karena DI LUAR git repo. Gunakan istilah generik di folder kode: "Akses ke server aplikasi" atau "See prod-docs/ for details".
5. **DILARANG** mengubah credential apapun (SSH key, DB password, API key di server).

### Kewajiban

1. **WAJIB** sync data dari server di awal sesi: pull repo terbaru, sync storage/logs jika diperlukan.
2. **WAJIB** catat setiap akses server di laporan maintenance sesuai aturan yang berlaku.
3. **WAJIB** pastikan local sinkron dengan production sebelum mulai kerja.

---

## Sample SSH Commands

```bash
# Akses server
ssh {ssh-config-name}

# Cek status server
ssh {ssh-config-name} 'cd /path/to/app && git status'

# Pull terbaru di server
ssh {ssh-config-name} 'cd /path/to/app && git pull'

# Sync storage dari server ke local (jika diperlukan)
rsync -avz --no-perms {ssh-config-name}:/path/to/app/storage/ ./storage/
```

---

## Server Directory Mapping

| Server | App Path | Storage Path | Log Path |
|--------|----------|-------------|----------|
| `{ssh-config-name}` | `{/var/www/app}` | `{/var/www/app/storage}` | `{/var/www/app/storage/logs}` |

---

## Maintenance Workflow (Hanya Jika MAINTENANCE_ACTIVE: true)

### Struktur Folder Maintenance

Folder maintenance ada di **root project** (bukan di dalam `dev-docs/`):

```text
{project-root}/
└── reports/
    └── maintenance/{tahun}/
        ├── KAK/
        │   └── kak-maintenance-{project}-{tahun}.md
        └── Laporan/
            ├── YYYY-MM-DD-laporan-maintenance-{project}.md  ← laporan utama/ringkasan
            ├── scope-{a,b,c}-{nama-scope}.md                ← laporan detail per scope
            └── assets/
                └── png/                                      ← diagram Mermaid → PNG
```

### Alur Kerja Maintenance

1. **AI memeriksa `MAINTENANCE_ACTIVE`** — jika false, hentikan. Tidak ada akses server.
2. **AI wajib membaca KAK** (Kerangka Acuan Kerja) dari `reports/maintenance/{tahun}/KAK/` — ini dokumen kontrak yang berisi scope pekerjaan maintenance.
3. **Jika KAK belum ada**, AI wajib membuat draft KAK berdasarkan:
   - Kondisi existing project (versi, stack, infrastruktur)
   - Backup production — WAJIB sebagai scope pertama
   - Audit keamanan/performa dari kondisi eksisting
   - Rencana upgrade/rekomendasi
4. **AI menjalankan task sesuai scope KAK** satu per satu
5. **Setiap scope selesai → laporan detail** di `scope-{a,b,c}-{nama-scope}.md`
6. **Laporan utama** (`YYYY-MM-DD-laporan-maintenance-{project}.md`) merangkum semua scope yang sudah/akan dikerjakan
7. Lihat template laporan di [maintenance/](./maintenance/)

### Aturan Backup Production (Wajib — Scope A)

1. Aplikasi di-zip di server, lalu diunduh ke local via `scp`
2. Database di-dump + gzip di server, lalu diunduh ke local via `scp`
3. Setiap backup wajib di-verifikasi integritasnya (file size, checksum)
4. Data backup disimpan di path backup yang sudah ditentukan
5. Lihat SOP lengkap: [maintenance/backup-procedure.md](./maintenance/backup-procedure.md)

---

## Git Repository Access di Server

> **Untuk setup repository di server** (clone, pull, deploy key, token), lihat: **[git-remote.md](./git-remote.md)**

File `git-remote.md` mengatur bagaimana server production mengakses git repository:
- Auto-detection remote URL dari local project
- Pilihan auth: SSH deploy key vs HTTPS token
- Setup credential store di server
- Migrasi dari SFTP/drag-drop ke git-based deploy

**Hubungan antar file:**

| File | Arah | Fungsi |
|------|------|--------|
| `ssh-access.md` (file ini) | Local → Server | AI SSH ke server, jalankan perintah |
| `git-remote.md` | Server → Git Repo | Server clone/pull kode dari GitHub/GitLab |

**Kapan keduanya dibutuhkan:**
- AI butuh SSH ke server **dan** server butuh akses ke git repo → pakai keduanya
- Server sudah punya akses ke git, AI tinggal SSH → cukup `ssh-access.md`
- Server belum ada, AI setup dari nol → pakai keduanya

---

## Deployment Commands

> **Gunakan command sesuai stack project.** Contoh untuk Laravel — ganti dengan command yang sesuai.

```bash
# Deploy (pull + build + restart)
ssh {ssh-config-name} 'cd /path/to/app && git pull && {php artisan migrate --force | npm run migrate | ...} && {php artisan config:cache | ...} && {php artisan queue:restart | pm2 restart | ...}'
```
