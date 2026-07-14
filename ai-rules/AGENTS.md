# AGENTS.md — AI Agent Working Contract

> **Status:** GUIDANCE FILE — Do NOT replace. This file tells AI agents HOW to work.
> **When deployed to a real project:** AI akan membaca ini sebagai kontrak kerja, tapi TIDAK boleh mengubah isinya. Yang diubah AI adalah file-file OUTPUT di `planning/` dan `dev-docs/`. AI TIDAK BOLEH mengubah file di `ai-rules/` (immutable templates).

---

##  CRITICAL: Git Location — READ FIRST

**`.git/` TIDAK berada di root project. Git repository ada di sub-folder kode!**

| Project Type | Git Location |
|------|-------------|
| Monolith | `apps/` |
| Fullstack | `backend/` dan `frontend/` |

**WAJIB — Setiap perintah git HARUS dijalankan dari dalam folder tersebut:**

```bash
# Monolith — cd dulu sebelum git commands
cd apps
git status
git pull --rebase

# Fullstack backend
cd backend
git status
```

**DILARANG KERAS:**
- ❌ **JANGAN `git init` di root project** — root BUKAN git repository
- ❌ **JANGAN menjalankan git commands dari root** — akan selalu gagal
- ❌ **JANGAN membuat `.git` baru di root** — git hanya di `apps/` atau `backend/`/`frontend/`

**Jika `git status` gagal:** Kamu lupa `cd` ke folder kode. Ulangi dengan `cd apps` (monolith) atau `cd backend` (fullstack).

---

## Purpose

File ini adalah kontrak kerja antara **human developer** dan **AI coding agent**. Setiap AI agent yang bekerja di repository ini WAJIB mematuhi aturan di bawah. Aturan ini **tidak dinegosiasikan** oleh AI.

---

## 0) Project Structure

> **Notasi `{apps}`:** Di seluruh file ini, `{apps}` adalah placeholder — ganti sesuai project type:
> - **Monolith:** `apps/` (1 folder kode, 1 repo git)
> - **Fullstack:** `backend/` dan `frontend/` (2 folder kode, 2 repo git terpisah)

### Saat Pertama Kali Project Dimulai

Saat user baru men-copy `ai-rules/` ke project baru, root project HANYA berisi:

```
project-root/
├── ai-rules/               ← IMMUTABLE — di-copy dari template docs-ai
│   ├── AGENTS.md           ← File ini — kontrak kerja AI
│   └── ...                 ← Template, aturan, panduan (AI hanya baca)
└── apps/                    ← Kode monolith — DI SINI GIT BERADA
    ├── .git/
    └── ...source code...
```

> Untuk fullstack: `apps/` diganti `backend/` dan `frontend/` (masing-masing punya `.git` sendiri).

### Setelah AI Mulai Bekerja (Target Structure)

AI akan **MEMBUAT** folder output dari template di `ai-rules/`. Folder output ini TIDAK ada saat project dimulai — dibuat oleh AI saat dibutuhkan:

```
project-root/
├── ai-rules/               ← IMMUTABLE — TIDAK PERNAH berubah
├── apps/ (atau backend/ + frontend/)   ← Kode aplikasi (git repo)

│   # Folder di bawah ini AKAN DIBUAT AI dari template di ai-rules/:
│
├── planning/               ← AKAN DIBUAT dari: ai-rules/planning-templates/
│   # Skenario: New, Revamp, Merger
│
├── dev-docs/               ← AKAN DIBUAT dari: ai-rules/dev-docs-ai-templates/ + architecture-templates/ + modules-template/
│   ├── CHANGELOG.md        ←    dari: ai-rules/CHANGELOG-template.md
│   ├── ai/                 ←    dari: ai-rules/dev-docs-ai-templates/
│   ├── architecture/       ←    dari: ai-rules/architecture-templates/
│   ├── modules/            ←    dari: ai-rules/modules-template/
│   ├── integrations/       ←    dari: ai-rules/integrations/
│   ├── decisions/          ←    dari: ai-rules/decisions/
│   ├── postman/            ←    dari: ai-rules/postman/ (jika ada external dev)
│   └── temp/               ←    AI scratchpad (tanpa template)
│   # Skenario: Semua
│
├── revamp/                 ← AKAN DIBUAT dari: ai-rules/revamp-templates/
│   # Skenario: Revamp, Merger
│
├── prod-docs/              ← AKAN DIBUAT dari: ai-rules/prod-docs-templates/
│   # Skenario: Production-ready (lalu di-scp ke server)
│
└── reports/                ← AKAN DIBUAT dari: ai-rules/reports-templates/
    ├── task/
    └── maintenance/
    # Skenario: Maintenance + setiap push task
```

### IMMUTABLE vs OUTPUT

| Area | Sifat | Dibuat/Dikelola Oleh | Kapan Ada |
|------|-------|---------------------|-----------|
| `ai-rules/` | IMMUTABLE | Human (copy dari template docs-ai) | Sejak awal |
| `apps/` / `backend/` / `frontend/` | Kode | AI membuat & mengisi | Sejak awal |
| `planning/` | OUTPUT | AI membuat dari `ai-rules/planning-templates/` | New / Revamp / Merger |
| `dev-docs/` | OUTPUT | AI membuat dari berbagai template di `ai-rules/` | Semua skenario |
| `revamp/` | OUTPUT | AI membuat dari `ai-rules/revamp-templates/` | Revamp / Merger |
| `prod-docs/` | OUTPUT | AI membuat dari `ai-rules/prod-docs-templates/` | Production-ready |
| `reports/` | OUTPUT | AI membuat dari `ai-rules/reports-templates/` | Maintenance + task reports |

### Aturan Folder Output

1. **AI MEMBUAT folder output** saat pertama kali akan menulis file di dalamnya:
   - `planning/` → saat akan mengisi file planning pertama kali (New/Revamp/Merger)
   - `dev-docs/` → saat akan menulis file dokumentasi pertama kali (Semua skenario)
   - `revamp/` → HANYA jika project adalah revamp/migrasi (Revamp/Merger)
   - `prod-docs/` → saat akan membuat dokumentasi server (Production-ready)
   - `reports/` → saat akan menulis laporan task/maintenance pertama kali
2. **AI TIDAK BOLEH memindahkan** folder output ke dalam folder kode (`apps/`, `backend/`, `frontend/`) atau ke `ai-rules/`
3. **AI UPDATE** konten folder output setiap selesai task (bukan buat ulang dari nol)
4. **Semua folder output TETAP di PROJECT ROOT** — paralel dengan `ai-rules/` dan folder kode (`apps/` untuk monolith, `backend/` + `frontend/` untuk fullstack)

### Perbedaan dev-docs/ vs prod-docs/

| Aspek | dev-docs/ | prod-docs/ |
|-------|-----------|------------|
| **Lokasi** | Di project repository | Di server production |
| **Konteks** | Development (kode, arsitektur aplikasi) | Operations (infrastruktur, deployment) |
| **Audience** | Developer | DevOps/SysAdmin/AI agent di server |
| **Isi** | Modules, decisions, integrations | Server specs, network topology, deployment process |
| **Update** | Setiap task development | Setiap perubahan di server |

**Kapan pakai prod-docs/:**
- Copy `prod-docs/` ke server production (biasanya ke `/root/` atau `/opt/docs/`)
- AI agent yang maintenance server akan baca dokumentasi ini
- Berisi informasi aktual server (topology, backup schedule, service status, dll)
- **Credential aktual (password, token, API key, SSH key) BOLEH di prod-docs/ karena folder ini DI LUAR git repo** — tidak akan di-push ke GitHub
- **DILARANG menulis credential aktual di file .md yang ada di dalam folder kode (`apps/`, `backend/`, `frontend/`)** — credential di folder kode HANYA boleh di `.env`

---

## 0a) CRITICAL: Root vs Inside Folder Kode — JANGAN CAMPUR

Ini adalah aturan LOKASI paling penting. Salah tempat = project kacau. AI WAJIB menghapal ini.

> **Note:** `{apps}` di tabel adalah placeholder — ganti sesuai project type: `apps/` (monolith) atau `backend/` + `frontend/` (fullstack).

| Item | Lokasi | Bisa Dipindah? |
|------|--------|:---:|
| `ai-rules/` | **Project ROOT** | ❌ JANGAN PERNAH — IMMUTABLE, AI hanya baca |
| `planning/` | **Project ROOT** | ❌ JANGAN PERNAH |
| `dev-docs/` | **Project ROOT** | ❌ JANGAN PERNAH |
| `reports/` | **Project ROOT** | ❌ JANGAN PERNAH |
| `prod-docs/` | **Project ROOT** | ❌ JANGAN PERNAH |
| `revamp/` | **Project ROOT** | ❌ JANGAN PERNAH |
| `{apps}/docs/operations/` | **DI DALAM folder kode** | ✅ PENGECUALIAN KHUSUS |
| `{apps}/README.md` | **DI DALAM folder kode** | ✅ Repo README yang muncul di GitHub |

**Aturan emas:**
- "Apakah ini TEMPLATE/RULE yang bersifat immutable?" → **`ai-rules/`** (AI hanya baca, tidak boleh ubah)
- "Apakah ini dokumentasi OUTPUT (planning, architecture, modules, AI contracts, changelog, version, revamp, prod-docs, reports)?" → **Project root (`planning/`, `dev-docs/`, `revamp/`, `prod-docs/`, `reports/`)**
- "Apakah ini file KONFIGURASI SERVER (supervisor, systemd, cronjob)?" → **`{apps}/docs/operations/`**
- "Apakah ini README yang muncul di GitHub repo?" → **`{apps}/README.md`**

**Kenapa harus begini:**
- `ai-rules/` adalah SATU-SATUNYA source yang di-copy ke project baru. Folder lain di root (`planning/`, `dev-docs/`, `revamp/`, `prod-docs/`, `reports/`) adalah OUTPUT yang dibuat oleh AI.
- `ai-rules/` + `planning/` + `dev-docs/` + `revamp/` + `prod-docs/` + `reports/` adalah artefak **HANYA untuk branch `dev`** — dikecualikan saat merge ke `main`
- `{apps}/docs/operations/` adalah file konfigurasi server — harus masuk ke `main` bersama kode
- Pemisahan ini memastikan dokumentasi development tidak mencemari branch `main`

---

## 0b) Git Remote & Repository Credentials

**AI WAJIB membaca `ai-rules/deployment/git-remote.md`** untuk setup deployment. File ini mendokumentasikan:

| Item | Purpose |
|------|---------|
| Repository URL (SSH + HTTPS) | Clone URL untuk development dan server production |
| Authentication mode | SSH key atau HTTPS token — pilih salah satu |
| Credential setup | Deploy key (server) atau git credential store |
| Auto-detection | AI membaca `git remote -v` dari local project untuk auto-fill |

**Menggantikan SFTP/drag-drop deployment:**
- Deployment berbasis git (`git pull` via SSH) menggantikan upload manual via FileZilla
- Rollback instan dengan `git reset --hard <hash>`
- AI bisa otomatis deploy: local push → server pull

> **File:** `ai-rules/deployment/git-remote.md` (immutable template) → `prod-docs/docs/operations/repository-access.md` (server aktual)

---

## 0c) Definisi Branch

- **`main`** = stabil / siap rilis / tidak boleh eksperimen.
- **`dev`** = pengembangan / integrasi.
- **(Opsional) `feat/<nama-fitur>`** = tempat AI mengerjakan 1 fitur spesifik.

**Kebijakan inti:**
- AI **tidak pernah** commit langsung ke `main`.
- Merge ke `main` hanya dari `dev` dan hanya setelah verifikasi.

---

## 0d) Branch Policy Khusus untuk ai-rules/, Output Folders, dan AGENTS.md

**Folder `ai-rules/`, `dev-docs/`, `planning/`, `revamp/`, `prod-docs/`, `reports/`, dan file `AGENTS.md` adalah artefak khusus branch development:**

- ❌ **DILARANG** commit/push `ai-rules/`, `dev-docs/`, `planning/`, `revamp/`, `prod-docs/`, `reports/`, atau `AGENTS.md` ke branch `main`
- ✅ **HANYA** boleh ada di branch `dev` dan `feat/*`
-  **Wajib** dihapus saat merge `dev → main`:
  ```bash
  cd apps                                     # atau cd backend (fullstack)
  git merge --no-commit --no-ff dev
  git restore --source=HEAD --staged --worktree ../ai-rules ../dev-docs ../planning ../revamp ../prod-docs ../reports ../AGENTS.md
  git commit -m "merge: dev -> main (exclude ai-rules + output folders + AGENTS)"
  ```
- 🗑️ **Wajib** di `.gitignore` untuk mencegah commit:
  ```gitignore
  /.commandcode/
  /.DS_Store/
  /dev-docs/temp/
  ```

- ⚠️ **Pengecualian untuk production:**
  - `FINAL_SYSTEM_HANDOVER.md` **boleh di-include** di `main`
  - File ini adalah reference handover untuk engineer/AI agent baru
  - Tidak mengandung data development atau kontrak kerja internal
  - **DILARANG** mengandung credential, IP server, atau secret apapun — hanya referensi ke `.env` atau `prod-docs/`

---

## 1) Aturan Keras (Non‑Negotiable)

1. **DILARANG commit/push ke `main`.**
2. **DILARANG `git push --force`** ke `main` atau `dev`.
3. **DILARANG ubah file sensitif** tanpa izin eksplisit user:
   - `.env`, `.env.*`, file secrets/keys/tokens, config production, credential.
   - **Pengecualian:** jika user memberi izin eksplisit, AI boleh mengubah `.env` untuk task tersebut.
   - Jika menambah key sensitif/operasional ke `.env`, AI **wajib** menambahkan placeholder key yang sesuai di `.env.example` pada batch yang sama.
4. **DILARANG refactor besar / sweeping changes** tanpa permintaan jelas.
5. **WAJIB batch kecil**: 1 perubahan kecil → 1 commit → push.
6. Jika requirement tidak jelas / risiko tinggi / perubahan besar:
   - **STOP → buat rencana singkat → minta persetujuan user.**
7. **WAJIB sinkronisasi dokumentasi OUTPUT `planning/*` dan `dev-docs/*` di setiap akhir task/batch**:
    - BACA template dari `ai-rules/planning-templates/`, `ai-rules/dev-docs-ai-templates/`, `ai-rules/architecture-templates/`, `ai-rules/modules-template/`
    - BUAT/UPDATE file OUTPUT di `planning/`, `dev-docs/ai/`, `dev-docs/architecture/`, `dev-docs/modules/`
    - review seluruh area `dev-docs/ai`, `dev-docs/architecture`, `dev-docs/decisions`, dan `dev-docs/modules`
    - update semua file yang terdampak agar tetap up-to-date terhadap implementasi terbaru
    - jangan lupa update `dev-docs/ai/FINAL_SYSTEM_HANDOVER.md` setelah push ke `dev`
    - **JANGAN UBAH file di `ai-rules/`** — itu immutable templates
    - **Jika tidak ada yang perlu diubah, tulis alasan singkat di output akhir**
8. **WAJIB MENGUSULKAN update `README.md` di folder kode** di setiap akhir task/batch jika ada:
   - perubahan fitur/kode di modul terdaftar
   - update versi modul
   - perubahan status modul (Planned → Production, dll)
   - **Ini adalah README yang muncul di GitHub repo — bukan `dev-docs/`**
   - **Monolith:** `{apps}/README.md`
   - **Fullstack:** `{backend}/README.md` dan `{frontend}/README.md`
   - Lihat template di `ai-rules/REPO_README_TEMPLATE.md`
   - **AI WAJIB mengusulkan draft perubahan** — user yang memutuskan apakah akan di-apply
   - **Jangan langsung mengubah file README tanpa persetujuan user**
9. **WAJIB mengikuti Security Standard** (`ai-rules/security/README.md`) di SEMUA project:
   - **Credential management:** SEMUA secret/credential di `.env` — DILARANG hardcode di kode. Cek Part A.
   - **HTTP security headers:** AI WAJIB setup tanpa diminta (CSP, HSTS, X-Frame-Options, dll). Cek Part B.
   - **Input validation:** Semua endpoint POST/PUT/DELETE WAJIB validasi input. Cek Part D.
   - **File upload:** Validasi MIME, batasi size, random filename, simpan di luar `public/`. Cek Part D.
   - **Pre-merge checklist:** Jalankan Security Pre-Merge Checklist (Part I) sebelum merge ke `main`.
   - AI WAJIB **proaktif** menerapkan security — bukan menunggu user meminta.
10. **WAJIB mengikuti UI/UX Template Rules** (`planning/PROJECT_BRIEF.md` section "UI/UX Template & Design System"):
    - **Jika user menyediakan HTML template** (contoh: Metronic 8, AdminLTE, Stisla):
      - ✅ **WAJIB** menggunakan struktur HTML, CSS, dan komponen dari template
      - ✅ **WAJIB** mengikuti naming convention dan class names dari template
      - ❌ **DILARANG** membuat UI components sendiri yang sudah ada di template
      - ❌ **DILARANG** override styling template kecuali sangat diperlukan
      - ✅ **BOLEH** extend/customize komponen template jika fitur tidak tersedia
    - **Jika user TIDAK menyediakan HTML template**:
      - ✅ **WAJIB** menggunakan framework UI established (Bootstrap, Tailwind, Material UI, dll)
      - ✅ **WAJIB** mengikuti best practices framework
      - ❌ **DILARANG** membuat CSS framework custom dari nol
      - ✅ **BOLEH** membuat custom CSS hanya untuk komponen yang tidak ada di framework
    - Lihat detail di `dev-docs/ai/PROJECT_CONTEXT.md` section "UI/UX Template & Framework".
11. **WAJIB membuat Operations Documentation** (`ai-rules/operations/README.md`) untuk setiap fitur yang butuh setup server:
    - **Fitur yang WAJIB punya dokumentasi operations:**
      - Queue worker (Redis, RabbitMQ, SQS)
      - Scheduler / Cronjob (daily cleanup, report generation, dll)
      - Supervisor / Process manager
      - Database backup script
      - SSL certificate renewal
      - Log rotation
      - Third-party service integration (webhook, API callback)
      - Health check endpoint
      - Monitoring setup (Prometheus, Grafana)
      - Cache warming / preloading
      - File storage sync (S3, MinIO)
      - Email queue / notification worker
12. **DILARANG menggunakan icons/emojis di kode atau dokumentasi**, kecuali:
    - ✅ dan ❌ **HANYA boleh** di dokumentasi untuk checklist/status
    - ❌ **DILARANG** menggunakan icons di kode (comments, variable names, UI text, dll)
    - ❌ **DILARANG** menggunakan decorative emojis (🔗🔒🛠️🎨📮🔄📊🚀📝🤖👨‍💻⛔🗑️⚠️ dll)
    - **Alasan:** Konsistensi, profesionalisme, dan compatibility lintas platform
13. **WAJIB mengikuti Coding Standards** (`ai-rules/coding-standards/CODING_STANDARDS.md`) untuk clean code:
    - **File size limits:** Controller max 1000, Service max 800, Model max 300, Route max 200
    - **Separation of Concerns:** Controller → Service → Repository → Model
    - **Framework conventions:** WAJIB ikuti pattern framework (Laravel Resource Controller, Express middleware, dll)
    - **Refactoring checklist:** WAJIB check sebelum commit (file size, function size, class responsibilities)
    - **Anti-patterns:** DILARANG God Controller, Fat Model, deep nesting, magic numbers
    - AI WAJIB **proaktif refactor** jika menemukan code smell
    - Jika file existing melanggar standar, laporkan di task report dan usulkan refactoring plan
      - WebSocket server
      - Real-time event processor
    - **Dokumentasi WAJIB include:**
      - Apa (nama service/fitur)
      - Kenapa (kenapa butuh setup di server)
      - Prerequisites (apa yang harus ada sebelum setup)
      - Step-by-step setup (cara setup lengkap)
      - Verifikasi (cara cek apakah setup berhasil)
      - Troubleshooting (masalah umum dan solusinya)
      - Maintenance (cara update / restart / stop)
    - **Lokasi:** `{apps|backend|frontend}/docs/operations/` — **PENGECUALIAN KHUSUS: HANYA operations docs yang diletakkan di dalam folder kode** (karena berisi config supervisor/systemd/cronjob yang harus ship bersama kode). Semua folder output lain (`planning/`, `dev-docs/`, `revamp/`, `prod-docs/`, `reports/`) **TETAP di PROJECT ROOT**, PARALEL dengan folder kode (`apps/` untuk monolith, `backend/` + `frontend/` untuk fullstack). JANGAN PERNAH dipindahkan ke dalam folder kode.
    - **Template:** Gunakan template di `ai-rules/operations/_templates/`
    - **Mode:** Default manual-setup (AI buat docs, user jalankan). Auto-setup hanya jika `AUTO_SETUP_OPERATIONS: true` di `ai-rules/deployment/ssh-access.md`
    - AI WAJIB **proaktif** membuat dokumentasi operations — bukan menunggu user meminta.
14. **DILARANG menulis credential aktual di file .md di dalam folder kode** (`apps/`, `backend/`, `frontend/`):
    - File di `{apps}/docs/operations/` berada DI DALAM git repo dan WILL di-push ke GitHub
    - **DILARANG** menulis: password, token, API key, SSH key, secret, database username, connection string aktual, server IP aktual
    - **WAJIB** gunakan referensi: `"See .env: DB_PASSWORD"`, `"Stored in .env"`, placeholder `{value_from_env}`, atau `"See prod-docs/ for details"`
    - **BOLEH** menulis: localhost, service name, port number (tanpa credential), deskripsi umum
    - **Pengecualian:** file .md di folder documentation di project root (`dev-docs/`, `prod-docs/`, `planning/`, `revamp/`, `reports/`) BOLEH mengandung credential karena DI LUAR git repo

---

## 2) Preflight Wajib (Sebelum Mulai Kerja)

**Selalu verifikasi folder kode sebelum menjalankan git commands!**

```bash
# Verifikasi folder kode (sebelum cd)
ls apps/.git 2>/dev/null && echo "Monolith OK" || \
ls backend/.git 2>/dev/null && echo "Fullstack backend OK" || \
echo "FOLDER KODE TIDAK DITEMUKAN — cek project type di ai-rules/README.md"

# Baru cd ke folder kode
cd apps          # atau cd backend (fullstack)
git status
git branch --show-current
git pull --rebase
```

**Syarat mulai kerja:**
- Working tree bersih (atau sudah di-commit / stash)
- Branch aktif **bukan `main`** (harus `dev` atau `feat/*`)

Jika masih di `main`:
```bash
git checkout dev
git pull --rebase
```

---

## 2a) Checkpoint Wajib (Sebelum AI Mengubah Apa Pun)

Jika ada perubahan lokal (sekecil apa pun), buat checkpoint:

```bash
cd apps          # atau cd backend
git add -A
git commit -m "chore: checkpoint before AI changes"
git push
```

Jika belum siap commit:
```bash
git stash push -u -m "WIP before AI"
```

---

## 3) Cara Kerja (Loop Aman per Batch)

AI wajib mengikuti siklus ini berulang:

### A) Rencana singkat (maks 6 bullet)
- Apa yang akan dibuat/diubah
- File target
- Risiko (DB/auth/config)
- Cara verifikasi

### B) Implementasi minimal
- Ubah seperlunya
- **Jangan** campur fitur + refactor besar dalam 1 batch

### C) Self‑review
```bash
cd apps && git diff    # atau cd backend && git diff
```
AI wajib menyebut:
- inti perubahan
- daftar file yang berubah
- hal yang perlu dicek manual

### D) Commit & push per milestone
```bash
cd apps          # atau cd backend
git add -A
git commit -m "feat: <ringkas perubahan>"
git push
```

**Contoh pesan commit bagus:**
- `feat: add survey list page`
- `fix: handle null response on dashboard`
- `refactor: simplify auth middleware` (hanya jika diminta)
- `chore: update deps`

---

## 4) Verifikasi Minimum (Wajib Sebelum Merge ke `main`)

Pilih sesuai stack project. Jika gagal → **jangan merge**.

### Laravel (PHP)
```bash
cd apps
php artisan test
# atau: vendor/bin/phpunit
```

### Node / Nuxt
```bash
cd apps          # atau cd backend / cd frontend
npm run lint
npm run build
```

### Go
```bash
cd apps
go test ./...
go vet ./...
```

---

## 5) Merge Policy: `dev` → `main` (Hanya Jika Sudah Aman)

```bash
cd apps          # atau cd backend (fullstack)

git checkout dev
git pull --rebase

git checkout main
git pull --rebase

git merge --no-commit --no-ff dev
git restore --source=HEAD --staged --worktree ../ai-rules ../dev-docs ../planning ../revamp ../prod-docs ../reports ../AGENTS.md
git commit -m "merge: dev -> main (exclude ai-rules + output folders + AGENTS)"
git push
```

**Aturan branch khusus:**
- Folder `ai-rules/`, `dev-docs/`, `planning/`, `revamp/`, `prod-docs/`, `reports/`, dan file `AGENTS.md` adalah artefak **khusus branch `dev`**.
- Saat merge ke `main`, semuanya **wajib dikecualikan** dengan `git restore --source=HEAD --staged --worktree ../ai-rules ../dev-docs ../planning ../revamp ../prod-docs ../reports ../AGENTS.md` sebelum commit merge.
- Jangan pernah menambahkan `ai-rules/`, `dev-docs/`, `planning/`, `revamp/`, `prod-docs/`, `reports/`, atau `AGENTS.md` ke staging saat merge ke `main`.

Setelah merge:
- lakukan smoke test singkat
- lanjut kerja kembali di `dev`

**Jika merge conflict saat `dev → main`:**
1. `git merge --abort` — batalkan merge
2. Merge `main` ke `dev` dulu untuk resolve conflict: `git checkout dev && git merge main`
3. Resolve semua conflict di branch `dev`
4. Commit: `git add -A && git commit -m "merge: main -> dev (resolve conflicts)"`
5. `git push`
6. Ulangi merge `dev → main` dari langkah awal

> Jika kamu pakai `feat/*`: merge `feat/* → dev` dulu, baru `dev → main`.

---

## 6) Scope Guardrails (Batas Perubahan)

AI **tidak boleh** tanpa izin eksplisit:
- mengubah struktur besar project
- mengganti framework/library inti
- mengubah auth/role/permission inti
- migrasi DB besar tanpa rencana + rollback
- mengubah konfigurasi production / secrets

Jika perlu:
- tulis rencana + langkah rollback + daftar file + cara verifikasi
- minta persetujuan user

---

## 7) Prosedur Darurat (Kalau Terjadi Kerusakan)

### A) Batalkan perubahan yang belum di‑commit
```bash
cd apps          # atau cd backend
git reset --hard HEAD
```

### B) Kembali ke commit aman sebelumnya (di `dev`/`feat`)
Cari commit:
```bash
cd apps
git log --oneline --decorate -20
```

Reset:
```bash
git reset --hard <HASH>
```

> Hindari force push. Jika terpaksa (kasus khusus):
```bash
git push --force-with-lease
```

### C) Jika sudah terlanjur merge ke `main`
Revert merge commit:
```bash
cd apps
git checkout main
git log --oneline --decorate -20
git revert -m 1 <MERGE_COMMIT_HASH>
git push
```

---

## 8) Output Wajib dari AI (Akhir Sesi)

AI harus mengeluarkan format ini:

1. **Summary** (1–5 poin)
2. **Files changed** (list)
3. **Verify commands** (yang harus dijalankan)
4. **Merge steps** (jika sudah layak `dev → main`)

**Jika belum aman untuk merge:** sebutkan kenapa dan apa yang perlu diperbaiki.

---

## 9) Quick Commands (Opsional, tapi dianjurkan)

Cek perbedaan sebelum merge:
```bash
cd apps && git diff main...dev
```

Cek branch & commit terakhir:
```bash
cd apps && git branch --show-current
cd apps && git log --oneline --decorate -10
```

---

## 10) Documentation Maintenance Protocol

### Anti-Monster Rule

**DILARANG membiarkan file dokumentasi tumbuh tanpa batas.** Setiap file yang mulai membengkak HARUS di-split atau di-arsipkan. Tujuannya: AI tidak membaca semua isi sekaligus — hanya apa yang relevan.

| Area | File | Strategi Anti-Monster |
|------|------|----------------------|
| `dev-docs/modules/` | `{modul}/README.md` | Split per aspek: `routes.md`, `controllers.md`, `models.md`, dll. README hanya indeks (jangan tumpuk semua isi di satu file) |
| `dev-docs/integrations/` | `README.md` | README hanya indeks. Detail per service di file sendiri (`midtrans.md`, dll) |
| `dev-docs/ai/` | `COMMIT_LOG.md` + `commit-logs/` | Hanya indeks. Detail commit split per hari: `commit-logs/YYYY-MM-DD.md` |
| `dev-docs/ai/` | `TASKS.md` | Hanya task aktif. Done >1 minggu → pindah ke `TASKS-ARCHIVE.md` |
| `dev-docs/ai/` | `KNOWN_ISSUES.md` | Hanya issue OPEN. Resolved >2 minggu → pindah ke `RESOLVED.md` |
| `ai-rules/troubleshooting/` | `README.md` | Quick reference + open issues. Resolved → pindah ke `resolved.md` |
| `dev-docs/` | `CHANGELOG.md` | Hanya tahun berjalan. Arsip per tahun: `CHANGELOG-{YYYY}.md` |

**Prinsip:** "Ketika AI membaca file, ia hanya membaca apa yang relevan, bukan semuanya."

### Maintenance Table

Setiap akhir task, AI WAJIB mengecek dan mengupdate file-file berikut (bila terdampak):

> **PERHATIKAN:** File di `ai-rules/` adalah IMMUTABLE — AI HANYA MEMBACA. Kolom "Kapan Diupdate" untuk file `ai-rules/` berarti "Kapan AI mereview" (membaca ulang), BUKAN "mengubah".

| Area | File | Kapan Direview / Diupdate |
|------|------|--------------------------|
| `ai-rules/security/` | `README.md` + semua Part | Saat ada perubahan auth/permission/role — AI BACA ulang guidance |
| `ai-rules/coding-standards/` | Semua file | Saat menemukan kode baru dengan pattern tidak dikenal — AI BACA ulang guidance |
| `ai-rules/deployment/` | `README.md`, `git-remote.md`, `ssh-access.md` | Saat environment/infra/deploy step berubah — AI BACA ulang guidance |
| `ai-rules/testing/` | `README.md` | Saat test framework/setup berubah — AI BACA ulang guidance |
| `ai-rules/troubleshooting/` | `README.md` | Saat menemukan error non-obvious — AI BACA ulang guidance |

| Area | File | Kapan Diupdate |
|------|------|--------------------------|
| `dev-docs/ai/` | `COMMIT_LOG.md` (indeks) + `commit-logs/YYYY-MM-DD.md` (detail) | SETIAP kali commit+push — WAJIB |
| `dev-docs/ai/` | `CURRENT_STATE.md` | Setiap selesai task |
| `dev-docs/ai/` | `TASKS.md` | Setiap task baru/selesai |
| `dev-docs/ai/` | `KNOWN_ISSUES.md` | Saat ada issue baru/terselesaikan |
| `dev-docs/ai/` | `FINAL_SYSTEM_HANDOVER.md` | Setelah push ke dev |
| `dev-docs/ai/` | `MODULE_MAP.md` | Saat ada modul baru/berubah |
| `dev-docs/ai/` | `TECHNICAL_DEBT.md` | Saat ada tech debt baru/terselesaikan |
| `dev-docs/ai/` | `PROJECT_CONTEXT.md` | Saat ada perubahan stack/struktur |
| `dev-docs/ai/` | `VERSION.md` | Saat mengisi/menutup `[Unreleased]` di CHANGELOG |
| `dev-docs/ai/` | `PROJECT_MENTAL_MODEL.md` | Saat pola arsitektur berubah |
| `dev-docs/architecture/` | Semua file | Saat ada perubahan desain sistem |
| `dev-docs/decisions/` | ADR files | Saat ada keputusan arsitektur baru |
| `dev-docs/modules/` | `*/README.md` + file split | Saat modul terdampak — IKUTI split-per-concern rule |
| `dev-docs/integrations/` | `README.md` | Saat third-party API/integrasi berubah |
| `dev-docs/postman/` | Collection + Environment + Developer Guide | Saat ada developer eksternal yang consume API |
| `dev-docs/CHANGELOG.md` | — | Setiap milestone/sprint selesai |
| `{apps}/README.md` (monolith) atau `{backend}/README.md` + `{frontend}/README.md` (fullstack) | Repo README | Setiap milestone / perubahan modul signifikan — lihat template `ai-rules/REPO_README_TEMPLATE.md` |
| `reports/task/` | `YYYY-MM-DD-{task}.md` | Setiap selesai push ke dev / merge ke main — WAJIB |
| `reports/maintenance/` | `{tahun}/Laporan/` | Setiap scope maintenance selesai |

**Jika tidak ada perubahan dokumentasi:** sebutkan alasannya secara eksplisit di output akhir.

---

# END

**Reminder:** 
- `main` harus tetap bersih & stabil. Semua kerja AI = `dev` / `feat/*`.
- **GIT SELALU dari dalam `apps/` (monolith) atau `backend/`/`frontend/` (fullstack).** Jangan dari root!
- **AI-rules/ adalah IMMUTABLE** — AI HANYA membaca, TIDAK BOLEH mengubah. Output AI di `planning/` dan `dev-docs/`.
