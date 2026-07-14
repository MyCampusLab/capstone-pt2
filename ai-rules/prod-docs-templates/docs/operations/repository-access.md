# Repository Access — Git Setup di Server Production

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Diisi dengan informasi aktual server production.
> **Purpose:** Dokumentasi bagaimana server production mengakses application repository. Ini adalah informasi spesifik server ini — beda dengan template di `ai-rules/deployment/git-remote.md` yang bersifat immutable.

---

## 1. Repository Access Status

| Field | Value |
|-------|-------|
| **Access Method** | `{SSH Deploy Key / HTTPS Token / SSH Agent Forwarding}` |
| **Setup Date** | `{YYYY-MM-DD}` |
| **Setup By** | `{AI Agent / nama_orang}` |
| **Repository** | `{git@github.com:owner/repo.git atau https://...}` |
| **Deploy Path** | `/var/www/{app_name}` |
| **Default Branch (Production)** | `{main}` |
| **Webhook Active** | `{Yes (URL: ...) / No}` |

---

## 2. Deploy Key Configuration

### (Jika Menggunakan SSH Deploy Key)

| Field | Value |
|-------|-------|
| Key Path (Server) | `/home/{user}/.ssh/id_ed25519_deploy` |
| Key Type | `{ed25519 / rsa}` |
| Passphrase | `{none / ada — tersimpan di ...}` |
| Added to GitHub/GitLab | `{Yes / No}` |
| Expiry | `{N/A (permanent) / YYYY-MM-DD}` |

**Public Key:**

```
{ssh-ed25519 AAAAC3... deploy@{server_name}}
```

**Setup command yang sudah dijalankan:**

```bash
# Generate (sudah dijalankan pada {YYYY-MM-DD})
ssh-keygen -t ed25519 -C "deploy@{server_name}" -f ~/.ssh/id_ed25519_deploy -N ""

# Test (sudah berhasil)
ssh -T git@github.com
# Output: Hi {username}! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 3. Token Configuration

### (Jika Menggunakan HTTPS + Personal Access Token)

| Field | Value |
|-------|-------|
| Token Type | `{GitHub classic / GitHub fine-grained / GitLab PAT}` |
| Token Location | `{Git credential store: ~/.git-credentials}` |
| Token Last Rotated | `{YYYY-MM-DD}` |
| Token Expiry | `{YYYY-MM-DD}` |
| Token Scopes | `{repo, workflow}` |

**Credential Store File (contoh — nilai aktual tidak ditampilkan):**

```bash
# ~/.git-credentials
https://{username}:{TOKEN_REDACTED}@github.com
```

**Setup command yang sudah dijalankan:**

```bash
# Setup credential store (sudah dijalankan pada {YYYY-MM-DD})
git config --global credential.helper store
git clone https://{username}:{token}@github.com/{owner}/{repo}.git /var/www/{app_name}
```

---

## 4. Deployment Commands

### Pull & Deploy (Production)

```bash
# SSH ke server
ssh {user}@{server}

# Pull dari branch production
cd /var/www/{app_name}
git fetch origin
git pull --rebase origin main

# Build & restart
{composer install --no-dev --optimize-autoloader}
{npm ci && npm run build}
{php artisan migrate --force}
{php artisan config:cache}
{php artisan queue:restart}
```

### Pull & Deploy (Staging)

```bash
ssh {user}@{server}
cd /var/www/{app_name}
git pull --rebase origin dev
{staging build commands}
```

### Rollback

```bash
ssh {user}@{server}
cd /var/www/{app_name}

# Lihat history
git log --oneline -20

# Rollback ke commit sebelumnya
git reset --hard HEAD~1

# Atau rollback ke commit spesifik
git reset --hard {hash_commit}

# Restart service
{restart commands}
```

### Cek Status

```bash
ssh {user}@{server}
cd /var/www/{app_name}
git status
git log --oneline -10
git remote -v
```

---

## 5. Webhook (Auto Deploy)

### (Jika Diaktifkan)

| Field | Value |
|-------|-------|
| Webhook URL | `{https://server.example.com/webhook/deploy}` |
| Webhook Secret | `{tersimpan di .env}` |
| Trigger Event | `{Push / Pull Request Merge}` |
| Auto Deploy Branch | `{main}` |

**Webhook Script (di server):**

```bash
# {/var/www/deploy.sh}
#!/bin/bash
# Auto-deploy script triggered by GitHub/GitLab webhook

APP_PATH="/var/www/{app_name}"
BRANCH="main"

cd "$APP_PATH"
git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date)] New commit detected. Deploying..."
    git pull --rebase origin $BRANCH
    {build commands}
    {restart commands}
    echo "[$(date)] Deploy complete."
else
    echo "[$(date)] No changes."
fi
```

---

## 6. Troubleshooting

### Server Tidak Bisa Pull

```bash
# Cek koneksi git
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."

# Cek remote config
cd /var/www/{app_name}
git remote -v
# Pastikan URL sudah benar

# Cek SSH key
ls -la ~/.ssh/
cat ~/.ssh/id_ed25519_deploy.pub
# Pastikan public key sudah terdaftar di GitHub/GitLab

# Cek credential store
cat ~/.git-credentials
# Pastikan token masih valid dan belum expired
```

### Merge Conflict Saat Pull

```bash
cd /var/www/{app_name}
git fetch origin

# Lihat apa yang conflict
git diff main..origin/main

# Hard reset jika ingin abaikan perubahan lokal
git reset --hard origin/main

# Atau stash perubahan lokal dulu
git stash
git pull --rebase origin main
git stash pop
```

### Permission Denied (SSH)

```bash
# Cek permissions SSH key
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519_deploy
chmod 644 ~/.ssh/id_ed25519_deploy.pub

# Test verbose
ssh -vT git@github.com
```

### Token Expired

```bash
# Gejala: "fatal: Authentication failed" atau "remote: Invalid username or password"

# LANGKAH-LANGKAH:
# 1. Buat token baru di GitHub/GitLab
# 2. Update credential di server:
nano ~/.git-credentials
# Ubah token yang lama dengan yang baru

# 3. Test
cd /var/www/{app_name}
git fetch origin
# Harusnya berhasil

# 4. Update catatan di ai-rules/deployment/git-remote.md
#    Update token expiry date
```

### File Permission Berubah Setelah Pull

```bash
# Setelah git pull, fix permissions
cd /var/www/{app_name}
sudo chown -R www-data:www-data .
sudo chmod -R 755 storage bootstrap/cache
sudo chmod -R 775 storage/logs storage/framework
```
