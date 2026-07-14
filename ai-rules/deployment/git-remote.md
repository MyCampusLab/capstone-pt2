# Git Remote & Repository Access

> **Status:** GUIDANCE + DATA FILE — AI auto-deteksi dari local project, atau user mengisi manual.
> **Purpose:** Single source of truth untuk akses git repository. **File ini mengatur "server ambil kode dari git"** — bukan "AI masuk ke server".
> **Beda dengan ssh-access.md:** `git-remote.md` = server → git repo. `ssh-access.md` = local → server. Keduanya bisa ada secara independen.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

### CRITICAL: Auto-Detection (Wajib Dilakukan AI Pertama Kali)

**Sebelum meminta user mengisi credential, AI WAJIB mencoba auto-detection:**

| Step | Command | Output yang Dicari |
|------|---------|-------------------|
| 1 | `cd {apps\|backend\|frontend} && git remote -v` | URL remote origin (fetch & push) |
| 2 | `cd {apps\|backend\|frontend} && git config --get remote.origin.url` | URL origin (alternatif) |
| 3 | `cd {apps\|backend\|frontend} && cat .git/config` | Full git config (jika steps di atas gagal) |

**Jika berhasil mendeteksi:**
- AI langsung mengisi kolom "Remote Repository" di bawah
- AI menganalisis tipe remote (SSH vs HTTPS) dan mengisi kolom Auth Mode

**Jika gagal (belum ada remote):**
- AI meminta user: "Repository belum terhubung ke remote. Apakah sudah ada repo di GitHub/GitLab?"
- Jika sudah: user memberikan URL, AI setup `git remote add origin`
- Jika belum: AI meminta user membuat repo dulu, baru lanjut

### Dual-Repo: Deteksi Per Repo

Untuk fullstack, deteksi di masing-masing folder:

| Repo | Command |
|------|---------|
| `backend` | `cd backend && git remote -v` |
| `frontend` | `cd frontend && git remote -v` |

### Aturan Keamanan Credential

1. **Token/credentials** di file ini menggunakan placeholder (`{token}`) — nilai aktual JANGAN di-commit
2. File ini adalah **referensi template** — nilai aktual masuk ke `.env` atau credential store di server
3. Jika user mengisi token di sini, AI WAJIB mengingatkan: "Token di file ini akan terlihat jika file di-push ke git repo. File output dari template ini (prod-docs/) berada DI LUAR git repo — safe untuk credential. Tapi DILARANG menyimpan token di file .md di dalam folder kode (apps/, backend/, frontend/)."
4. Untuk production: token disimpan di server via `git credential-store`, **bukan** di file project

---

## 1. Remote Repository

> **Diisi AI secara otomatis (auto-detection) atau user secara manual.**

### Detected / Manual Input

| Field | Value |
|-------|-------|
| **Platform** | `{GitHub / GitLab / Bitbucket / Self-hosted}` |
| **Repository Name** | `{owner/repo}` |
| **Remote Name** | `{origin}` — default: `origin` |
| **Clone URL (SSH)** | `{git@github.com:owner/repo.git}` |
| **Clone URL (HTTPS)** | `{https://github.com/owner/repo.git}` |
| **Default Branch** | `{main / master}` |
| **Development Branch** | `{dev}` |

### Remote URLs — Full Detection Detail

> **Diisi AI setelah `git remote -v`:**

| Remote | Fetch URL | Push URL |
|--------|-----------|----------|
| `{origin}` | `{url}` | `{url}` |
| `{upstream}` | `{url — jika ada fork}` | `{url}` |
| `{release}` | `{url — jika ada}` | `{url}` |

### Multiple Remotes (Jika Ada)

| Scenario | Remote | Purpose | URL |
|----------|--------|---------|-----|
| Fork | `origin` | Repo pribadi (push) | `{url}` |
|  | `upstream` | Repo sumber (fetch sync) | `{url}` |
| Separate BE/FE | `origin` (backend) | Backend repository | `{url}` |
|  | `origin` (frontend) | Frontend repository | `{url}` |

### Fullstack: Backend & Frontend Remote

| Repo | Remote | URL | Default Branch |
|------|--------|-----|----------------|
| `{backend}` | `origin` | `{url}` | `{main}` |
| `{frontend}` | `origin` | `{url}` | `{main}` |

---

## 2. Authentication Mode

> **Pilih salah satu — AI bisa mendeteksi dari URL remote.**

### Mode A: SSH Key (Recommended — Lebih Aman)

**Terdeteksi jika:** URL remote diawali `git@` (contoh: `git@github.com:owner/repo.git`)

| Field | Value |
|-------|-------|
| Mode | SSH |
| SSH Key Path (local) | `{~/.ssh/id_ed25519 / ~/.ssh/id_rsa}` |
| SSH Config Host (jika ada) | `{github.com / gitlab.com}` |
| Key Type | `{ed25519 / rsa}` |

**Setup SSH key (jika belum ada):**

```bash
# 1. Generate SSH key (local)
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519_github

# 2. Add to SSH config (~/.ssh/config)
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes

# 3. Add public key to GitHub/GitLab
cat ~/.ssh/id_ed25519_github.pub
# Copy output ke: GitHub Settings > SSH and GPG keys > New SSH Key
# Atau: GitLab Settings > SSH Keys

# 4. Test connection
ssh -T git@github.com    # GitHub
ssh -T git@gitlab.com    # GitLab
# Expected: "Hi username! You've successfully authenticated..."
```

### Mode B: HTTPS + Personal Access Token (PAT)

**Terdeteksi jika:** URL remote diawali `https://` (contoh: `https://github.com/owner/repo.git`)

| Field | Value |
|-------|-------|
| Mode | HTTPS + Token |
| Username | `{github/gitlab username}` |
| Token | `{token — JANGAN COMMIT KE REPO}` |
| Token Type | `{classic / fine-grained — GitHub} atau {Personal Access Token — GitLab}` |
| Token Expiry | `{YYYY-MM-DD atau "Never"}` |
| Token Scopes | `{repo + workflow — GitHub} atau {read_repository + write_repository — GitLab}` |
| Token Disimpan di | `{~/.git-credentials (local) / server git credential-store}` |

**Cara Membuat Token:**

| Platform | URL | Minimal Scopes |
|----------|-----|---------------|
| GitHub (classic) | https://github.com/settings/tokens | `repo`, `workflow` |
| GitHub (fine-grained) | https://github.com/settings/tokens?type=beta | Repository access, Contents: Read & Write |
| GitLab | https://gitlab.com/-/profile/personal_access_tokens | `read_repository`, `write_repository` |
| Bitbucket | https://bitbucket.org/account/settings/app-passwords/ | Repository: Read, Write |

**Setup token di local (opsional — untuk AI jika akses via HTTPS):**

```bash
# Simpan credential (local)
git config --global credential.helper store
# Lalu git pull/push sekali — akan prompt username + token, lalu disimpan
```

---

## 3. Production Server Git Setup

### CRITICAL: Dari SFTP Drag-Drop ke Git-Based Deploy

**Jika project sebelumnya deploy manual via SFTP/FileZilla:**

```bash
# DI SERVER — migrate ke git-based deploy:

# 1. Backup existing code (SAFETY FIRST!)
sudo cp -r /var/www/{app_name} /var/www/{app_name}.backup.$(date +%Y%m%d)

# 2. Clone fresh dari repository
cd /var/www
sudo git clone {CLONE_URL} {app_name}

# 3. Restore .env dari backup (credentials tidak di repo!)
sudo cp /var/www/{app_name}.backup.$(date +%Y%m%d)/.env /var/www/{app_name}/.env

# 4. Restore uploads/storage dari backup (user-generated content)
sudo cp -r /var/www/{app_name}.backup.$(date +%Y%m%d)/storage/app/public /var/www/{app_name}/storage/app/ 2>/dev/null || true

# 5. Set permissions
sudo chown -R www-data:www-data /var/www/{app_name}
```

### Setup Git Credential di Server (Pilih Salah Satu)

**Opsi A: Deploy Key (SSH — Recommended untuk Server)**

```bash
# 1. Generate deploy key di server (tanpa passphrase)
ssh-keygen -t ed25519 -C "deploy@{server_name}" -f ~/.ssh/id_ed25519_deploy -N ""

# 2. Add public key ke GitHub/GitLab sebagai Deploy Key
cat ~/.ssh/id_ed25519_deploy.pub
# GitHub: Repo Settings > Deploy Keys > Add Deploy Key (Check "Allow write access" jika perlu push)
# GitLab: Repo Settings > Repository > Deploy Keys

# 3. Test connection
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."

# 4. Clone/pull akan otomatis pakai key ini
```

**Opsi B: Git Credential Store (HTTPS + Token — Jika SSH Diblokir)**

```bash
# 1. Setup credential storage
git config --global credential.helper store

# 2. Clone dengan token (akan menyimpan credential)
git clone https://{username}:{token}@github.com/{owner}/{repo}.git /var/www/{app_name}

# Atau untuk repo yang sudah ada:
cd /var/www/{app_name}
git remote set-url origin https://{username}:{token}@github.com/{owner}/{repo}.git
git pull  # akan trigger credential storage

# 3. Verifikasi
cat ~/.git-credentials
# Akan berisi: https://{username}:{token}@github.com
```

**Opsi C: Git InsteadOf (HTTPS → SSH — Jika Server Support SSH tapi Repo HTTPS)**

```bash
# Redirect HTTPS requests ke SSH
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
```

### Verifikasi Setup di Server

```bash
# Test git access
cd /var/www/{app_name}
git fetch origin
git status
git log --oneline -5
echo "SUCCESS: Repository accessible, git-based deploy ready"
```

---

## 4. AI Deployment Workflow

### Alur Deployment Berbasis Git (Menggantikan SFTP Drag-Drop)

```
                    LOCAL (MacBook)                          SERVER (Production)
                    ================                         ===================
                    
1. AI kerjakan coding    |
   cd {folder_kode}      |
   git add -A            |
   git commit -m "..."   |
   git push              |
                          |  git push origin dev
                          +-------------------------------->
                                                          2. AI SSH ke server
                                                             ssh user@server
                                                          
                                                          3. AI pull di server
                                                             cd /var/www/app
                                                             git pull origin dev
                                                          
                                                             Atau untuk main:
                                                             git pull origin main
                                                          
                                                          4. AI jalankan build
                                                             composer install --no-dev
                                                             npm run build
                                                             php artisan migrate --force
                                                          
                                                          5. AI restart service
                                                             php artisan queue:restart
                                                             systemctl reload nginx
```

**Keunggulan vs SFTP Drag-Drop:**

| Aspek | SFTP Drag-Drop | Git-Based Deploy |
|-------|---------------|-----------------|
| Akurasi | Manual, rawan missed file | Otomatis, semua file dari commit |
| Rollback | Tidak bisa (kecuali manual backup) | `git checkout <hash>` instan |
| History | Tidak ada | `git log` — tahu siapa, kapan, kenapa |
| Kolaborasi | Hanya 1 orang | Multi-developer via branch |
| AI automation | Tidak bisa diotomatisasi AI | AI bisa full SSH + git pull |
| Kecepatan | Upload semua file ulang | Hanya transfer delta (yang berubah) |

---

## 5. Quick Reference untuk AI

### Clone Repository (Pertama Kali)

```bash
# SSH (jika deploy key sudah di-setup)
git clone git@github.com:{owner}/{repo}.git /var/www/{app_name}

# HTTPS + Token (jika SSH diblokir) — token disimpan di credential store, JANGAN inline di command yang masuk git
git clone https://github.com/{owner}/{repo}.git /var/www/{app_name}
# Setelah clone, setup credential store untuk auth:
git config --global credential.helper store
```

### Pull Update (Rutin)

```bash
cd /var/www/{app_name}
git fetch origin
git checkout {branch}          # main untuk production, dev untuk staging
git pull --rebase origin {branch}
```

### Rollback

```bash
cd /var/www/{app_name}
git log --oneline -20          # cari hash commit yang aman
git reset --hard {hash_commit}
# Atau: git checkout {hash_commit} untuk temporary
```

### Cek Status di Server

```bash
cd /var/www/{app_name}
git status                     # ada perubahan lokal?
git log --oneline -10          # commit terakhir
git remote -v                  # remote URL
```

---
