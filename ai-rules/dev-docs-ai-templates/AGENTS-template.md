# AGENTS (AI Working Contract for This Repo)

> **Status:** GUIDANCE FILE — Do NOT replace. AI harus mengikuti kontrak ini tapi TIDAK boleh mengubah isinya.
> **Purpose:** Ringkasan aturan kerja spesifik untuk repository ini. Melengkapi `AGENTS.md` root.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Project Type

**Lihat deklarasi di `PROJECT_CONTEXT.md` section "Project Type Declaration".** Jika project ini:
- **Monolith** → hanya ada 1 repo (`apps/`) → isi 1 kontrak di bawah
- **Fullstack** → ada 2 repo (`backend/` + `frontend/`) → isi **2 section terpisah**: Backend Rules dan Frontend Rules

Untuk fullstack, aturan coding backend dan frontend bisa sangat berbeda (framework, convention, test tools). Jangan campur.

---

## 1) Project Identity

| Item | Value |
|------|-------|
| Project Type | `{Monolith / Fullstack}` |
| Repo(s) | `{apps/ — monolith} / {backend/ + frontend/ — fullstack}` |
| Git Folder | `{cd apps | cd backend + cd frontend}` |

---

## 2) Common Rules (Berlaku untuk Semua Repo)

### Branch and Git Policy

**Isi oleh AI saat pertama kali menganalisis repo:**
- Sebutkan branch aktif untuk development (`dev` atau lainnya)
- Konfirmasi kebijakan branch yang berlaku
- Tambahkan aturan git spesifik project (misal: signed commits, branch naming convention)

```markdown
## Branch and Git Policy

1. Kerja di `{branch_development}` (atau `feat/*`), bukan `main`.
2. Jangan force push ke `main`/`{branch_development}`.
3. Lakukan batch kecil: perubahan jelas, commit jelas.
4. Preflight: `cd {folder_kode} && git status && git branch --show-current && git pull --rebase`

5. [Tambahan spesifik project]
```

### Change Scope Rules

```markdown
## Change Scope Rules

- Hindari refactor besar tanpa kebutuhan langsung.
- Jangan sentuh konfigurasi sensitif/secret.
- Fokus pada root cause, bukan symptom patch.

- [Tambahan spesifik project]
```

### Commit Message Format + COMMIT_LOG

```markdown
## Commit Message Format

Format: `type: judul singkat`

Body (2-5 baris):
- Apa yang dikerjakan
- Kenapa dilakukan
- Dampak perubahan

Co-authored-by: {nama_model_AI}
```

**COMMIT_LOG:** Setiap commit wajib dicatat di `dev-docs/ai/commit-logs/YYYY-MM-DD.md` + update indeks di `COMMIT_LOG.md`.

---

## 3A) Backend-Specific Rules (Hanya Fullstack)

> **Isi section ini jika project fullstack.** Untuk monolith, langsung ke section 4.

### Coding and Architecture

```markdown
## Backend Rules

- Framework: {Laravel / Express / Go / ...}
- Route pattern: {REST / GraphQL / ...}
- Auth: {Sanctum / JWT / Session / ...}
- Testing: {PHPUnit / Jest / Go test / ...}

- [Konvensi spesifik backend — namespace, controller pattern, service layer, dll]
```

### Backend Dependencies on Frontend

- API contract di `../planning/api-contract.md`
- Backend harus comply ke kontrak yang sudah disepakati
- Jika ada perubahan endpoint → update API contract + beri tahu (atau AI akan update frontend juga)

---

## 3B) Frontend-Specific Rules (Hanya Fullstack)

### Coding and Architecture

```markdown
## Frontend Rules

- Framework: {Nuxt / Next.js / React / Vue SPA / ...}
- Rendering: {SSR / SPA / SSG / ...}
- State management: {Pinia / Redux / ...}
- Styling: {Tailwind / Bootstrap / CSS Modules / ...}
- Testing: {Vitest / Jest / Playwright / ...}

- [Konvensi spesifik frontend — component pattern, page structure, dll]
```

### Frontend Dependencies on Backend

- API base URL dari `.env` (`API_BASE_URL`)
- Konsumsi endpoint sesuai `../planning/api-contract.md`
- Jika backend berubah → update frontend sesuai kontrak baru

---

## 4) Repo README Maintenance (Wajib!)

**Untuk semua project type (monolith & fullstack):**

```markdown
## Repo README Maintenance

Setiap repo kode (apps/ atau backend/ + frontend/) WAJIB punya `README.md`
yang selalu up-to-date. Ini adalah GitHub repo README — wajah project di GitHub.

- **Template:** Lihat `REPO_README_TEMPLATE.md`
- **Kapan update:** Setiap milestone / perubahan signifikan selesai
- **Minimal isi:** tech stack, cara setup, struktur project, module list
- **Monolith:** `{apps}/README.md`
- **Fullstack:** `{backend}/README.md` dan `{frontend}/README.md`

README repo harus bisa dijadikan panduan onboarding engineer baru tanpa membaca
seluruh dev-docs/.
```

---

## 5) Task Reporting Rules

**Untuk semua project type (monolith & fullstack):**

```markdown
## Task Reporting Rules

Setiap task selesai + push, buat laporan:

- Monolith: `reports/task/YYYY-MM-DD-{task}.md`
- Fullstack: `reports/task/backend/YYYY-MM-DD-{task}.md` atau `reports/task/frontend/YYYY-MM-DD-{task}.md`

Isi: deskripsi, tujuan, file diubah, snapshot before vs after, UAT
Wajib UAT mandiri sebelum push — test sukses & edge case
```

---

## 5) Communication Style

```markdown
## Communication Style for Future Agents

- Ringkas, langsung ke hasil.
- Bedakan fakta vs asumsi.
- Untuk ketidakpastian tulis: **Assumption based on repository analysis**.
- Gunakan format tabel untuk data terstruktur.
- Selalu sebutkan file path lengkap saat merujuk kode.
```
