# Credential & Secret Management (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  HARD RULES — Jangan Dilanggar

1. **SEMUA credential WAJIB di `.env`** — API keys, DB password, token, secret key, OAuth client secret, SMTP password, S3 access key. Tidak ada pengecualian.
2. **`.env` WAJIB di `.gitignore`** — pastikan tidak pernah ter-commit. Cek: `cd {folder_kode} && git status` tidak menampilkan `.env`.
3. **`.env.example` WAJIB ada** — berisi semua key dengan value kosong atau placeholder, tanpa credential real.
4. **DILARANG hardcode credential** di file config, controller, service, atau file apapun. Semua credential dipanggil via `env('KEY')` atau environment variable.
5. **Token/seeder password default** WAJIB di `.env`, bukan hardcode di seeder file.
6. **Secret scanning WAJIB aktif** — gunakan tool seperti `trufflehog`, `git-secrets`, atau `gitleaks` untuk mencegah credential leak di git history.
7. **`.env` file permissions** — set ke `600` (read/write owner only) di production server.
8. **Environment separation** — gunakan `.env.development`, `.env.staging`, `.env.production` yang berbeda. Jangan pakai credential production di development.
9. **Secret rotation policy** — semua credential sensitif (API keys, JWT secret) WAJIB di-rotate setiap 90 hari untuk production.
10. **Encryption at rest** — data sensitif di database (PII, financial data, health data) WAJIB di-encrypt menggunakan AES-256 atau setara.
11. **DILARANG menulis credential aktual di file .md yang ada di dalam folder kode (`apps/`, `backend/`, `frontend/`)** — termasuk file di `{apps}/docs/operations/`, README.md, dan file dokumentasi lainnya. Credential (password, token, API key, SSH key, secret, database username, connection string, server IP) HANYA boleh di `.env`. File .md di folder kode WAJIB menggunakan referensi: `"Lihat .env"` atau `"Stored in .env"` atau placeholder `{value_from_env}`. Pengecualian: file .md di folder documentation di project root (`dev-docs/`, `prod-docs/`, `planning/`, `revamp/`, `reports/`) BOLEH mengandung credential karena berada DI LUAR git repository.

```bash
# Contoh benar (.env):
APP_KEY=base64:...
DB_PASSWORD=secret123
MAIL_PASSWORD=secret456
AWS_ACCESS_KEY_ID=AKIA...
JWT_SECRET=random-string-here
DEFAULT_ADMIN_PASSWORD=admin123

# Contoh benar (.env.example):
APP_KEY=
DB_PASSWORD=
MAIL_PASSWORD=
AWS_ACCESS_KEY_ID=
JWT_SECRET=
DEFAULT_ADMIN_PASSWORD=
```

```php
// Contoh benar (config/app.php):
'key' => env('APP_KEY'),
'cipher' => 'AES-256-CBC',

// Contoh benar (seeder):
User::create([
    'name' => 'Admin',
    'email' => 'admin@example.com',
    'password' => Hash::make(env('DEFAULT_ADMIN_PASSWORD', 'change-me')),
]);
```

```javascript
// Contoh benar (Node.js):
const apiKey = process.env.API_KEY; // BUKAN: const apiKey = 'sk-abc123...'
```

```markdown
# Contoh benar (.md di dalam folder kode — apps/docs/operations/):
| Setting | Value |
|---------|-------|
| DB Host | localhost |
| DB Password | See .env: DB_PASSWORD |
| API Key | See .env: API_KEY |
| Server IP | See prod-docs/docs/architecture/overview.md |

# Contoh SALAH (.md di dalam folder kode):
| Setting | Value |
|---------|-------|
| DB Host | 10.35.4.60 |          ← DILARANG — IP di .md di git repo
| DB Password | MyP@ssw0rd123 |    ← DILARANG — password di .md di git repo
| API Key | sk-abc123... |          ← DILARANG — key di .md di git repo
| Server IP | 203.0.113.5 |        ← DILARANG — IP di .md di git repo
```

**6. File sensitif yang WAJIB di `.gitignore`:**
```gitignore
# Environment
.env
.env.*
!.env.example

# Credentials
*.pem
*.key
*.p12
*.pfx
credentials.json
service-account.json

# Dependencies
/vendor/
/node_modules/

# Build
/dist/
/build/
/public/build/

# IDE
/.idea/
/.vscode/

# OS
.DS_Store
Thumbs.db

# AI
/.commandcode/
```

7. **AI WAJIB memeriksa** sebelum commit: `cd {folder_kode} && git diff --cached` — pastikan tidak ada credential atau file sensitif yang ter-stage.

---

Kembali ke [Index](./README.md)
