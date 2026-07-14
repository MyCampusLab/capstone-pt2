# {Nama Project} — {Tagline Singkat}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Auto-generated oleh AI. Diupdate setiap milestone. Lihat `../dev-docs/` untuk dokumentasi development lengkap.**

---

## Apa Ini?

**{1-2 kalimat — apa aplikasi ini, untuk siapa, masalah apa yang diselesaikan}**

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | `{Go / PHP / Node.js / ...}` |
| Framework | `{Fiber / Laravel / Express / ...}` |
| Database | `{PostgreSQL / MySQL / ...}` |
| Cache | `{Redis / ...}` |
| Queue | `{Redis Streams / ...}` |
| Storage | `{MinIO / S3 / Local}` |

---

## Quick Start

### Prerequisites

- `{runtime & version}`
- `{database & version}`
- `{package manager}`

### Setup

```bash
# Clone
git clone {repo_url}
cd {project_folder}

# Install dependencies
{go mod tidy | npm install | composer install}

# Setup environment
cp .env.example .env
# Edit .env — isi credential yang diperlukan

# Setup database
{go run main.go migrate | php artisan migrate | npm run migrate}

# Seed data (opsional)
{go run main.go seed | php artisan db:seed}

# Run dev server
{go run main.go | npm run dev | php artisan serve}
```

### Access

| Service | URL |
|---------|-----|
| API | `http://localhost:{port}` |
| Frontend | `http://localhost:{port}` |

---

## Project Structure

```
{apps|backend|frontend}/
├── {src/app}/
│   ├── {controllers/handlers}/
│   ├── {models/entities}/
│   ├── {services}/
│   └── {routes}/
├── {database/migrations}/
├── {config}/
├── {tests}/
└── {main.go / index.js / index.php}
```

---

## Modules

| Module | Deskripsi | Status |
|--------|----------|--------|
| `{nama_modul}` | `{fungsi}` | `{Production / In Progress / Planned}` |

---

## API Documentation

| Method | Endpoint | Auth | Deskripsi |
|--------|----------|------|----------|
| `GET` | `/api/v1/{resource}` | `{role}` | `{deskripsi}` |

> Lihat `../planning/api-contract.md` untuk kontrak API lengkap.

---

## Testing

```bash
# Run all tests
{go test ./... | npm test | php artisan test}

# Run specific suite
{go test ./... -run TestName | npm test -- --grep pattern}
```

---

## Deployment

```bash
# Production build
{go build | npm run build | composer install --no-dev}

# Run
{./binary | node dist/index.js | php artisan serve --env=production}
```

> Lihat `../dev-docs/deployment/README.md` untuk panduan deployment lengkap.

---

## Contributing

- **Branch:** `dev` untuk development, `main` untuk production
- **Commit:** Format `type: judul` (contoh: `feat: add user authentication`)
- **Review:** Semua perubahan wajib melalui code review dan testing sebelum merge

---

**Last Updated:** {YYYY-MM-DD}
dated:** {YYYY-MM-DD}
