# ai-rules/ -- Master Template untuk Vibe Coding

> **Status:** IMMUTABLE -- AI TIDAK BOLEH mengubah file apapun di folder ini.
> **Purpose:** Semua panduan, aturan, dan template yang dibutuhkan AI untuk bekerja.

## Cara Pakai AI

1. **PERTAMA KALI:** Baca `AGENTS.md` di folder ini
2. Baca file ini untuk memahami struktur ai-rules
3. Setiap kali butuh aturan: cari di sub-folder yang sesuai
4. Setiap kali butuh buat output: cari template di kolom "Template Source"

## Mapping: Template -> Output

### Folder Output: `planning/` (New / Revamp / Merger)

| File Output | Template Source | Keterangan |
|-------------|----------------|------------|
| `planning/PROJECT_BRIEF.md` | `ai-rules/planning-templates/_PROJECT_BRIEF_TEMPLATE.md` | Brief project (13 section) |
| `planning/prd.md` | `ai-rules/planning-templates/prd.md` | Product Requirements Document |
| `planning/architecture.md` | `ai-rules/planning-templates/architecture.md` | Tech stack + system design |
| `planning/database.md` | `ai-rules/planning-templates/database.md` | ERD + schema plan |
| `planning/modules.md` | `ai-rules/planning-templates/modules.md` | Module/feature breakdown |
| `planning/api-contract.md` | `ai-rules/planning-templates/api-contract.md` | API contract (fullstack) |
| `planning/wireframe.md` | `ai-rules/planning-templates/wireframe.md` | UI/UX plan |
| `planning/timeline.md` | `ai-rules/planning-templates/timeline.md` | Milestones + release plan |

### Folder Output: `dev-docs/` (Semua Skenario)

| File/Folder Output | Template Source | Keterangan |
|--------------------|----------------|------------|
| `dev-docs/CHANGELOG.md` | `ai-rules/CHANGELOG-template.md` | Log perubahan kronologis |
| `dev-docs/ai/PROJECT_CONTEXT.md` | `ai-rules/dev-docs-ai-templates/PROJECT_CONTEXT-template.md` | System overview |
| `dev-docs/ai/PROJECT_MENTAL_MODEL.md` | `ai-rules/dev-docs-ai-templates/PROJECT_MENTAL_MODEL-template.md` | Architectural patterns |
| `dev-docs/ai/MODULE_MAP.md` | `ai-rules/dev-docs-ai-templates/MODULE_MAP-template.md` | Module-to-code mapping |
| `dev-docs/ai/AGENTS.md` | `ai-rules/dev-docs-ai-templates/AGENTS-template.md` | Repo-level AI contract |
| `dev-docs/ai/CODING_RULES.md` | `ai-rules/dev-docs-ai-templates/CODING_RULES-template.md` | Project coding conventions |
| `dev-docs/ai/CURRENT_STATE.md` | `ai-rules/dev-docs-ai-templates/CURRENT_STATE-template.md` | Current dev state |
| `dev-docs/ai/START_HERE.md` | `ai-rules/dev-docs-ai-templates/START_HERE-template.md` | Onboarding entry point |
| `dev-docs/ai/TASKS.md` | `ai-rules/dev-docs-ai-templates/TASKS-template.md` | Active task tracking |
| `dev-docs/ai/FINAL_SYSTEM_HANDOVER.md` | `ai-rules/dev-docs-ai-templates/FINAL_SYSTEM_HANDOVER-template.md` | Handover doc |
| `dev-docs/ai/TECHNICAL_DEBT.md` | `ai-rules/dev-docs-ai-templates/TECHNICAL_DEBT-template.md` | Tech debt tracking |
| `dev-docs/ai/KNOWN_ISSUES.md` | `ai-rules/dev-docs-ai-templates/KNOWN_ISSUES-template.md` | Open issues |
| `dev-docs/ai/VERSION.md` | `ai-rules/dev-docs-ai-templates/VERSION-template.md` | Version tracking |
| `dev-docs/ai/TASKS-ARCHIVE.md` | `ai-rules/TASKS-ARCHIVE-template.md` | Archived tasks |
| `dev-docs/ai/RESOLVED.md` | `ai-rules/RESOLVED-template.md` | Resolved issues |
| `dev-docs/ai/COMMIT_LOG.md` | `ai-rules/COMMIT_LOG-template.md` | Commit log index |
| `dev-docs/ai/commit-logs/YYYY-MM-DD.md` | (tanpa template -- dibuat AI) | Daily commit log |
| `dev-docs/architecture/api-flow.md` | `ai-rules/architecture-templates/api-flow.md` | API flow |
| `dev-docs/architecture/backend-structure.md` | `ai-rules/architecture-templates/backend-structure.md` | Backend structure |
| `dev-docs/architecture/database.md` | `ai-rules/architecture-templates/database.md` | Database architecture |
| `dev-docs/architecture/frontend-structure.md` | `ai-rules/architecture-templates/frontend-structure.md` | Frontend structure |
| `dev-docs/modules/{modul}/*.md` | `ai-rules/modules-template/_template/*.md` | Per-module docs (8 file) |
| `dev-docs/integrations/{service}.md` | `ai-rules/integrations/_template.md` | Third-party API docs |
| `dev-docs/decisions/NNN-description.md` | `ai-rules/decisions/001-architecture.md` | ADR records |
| `dev-docs/postman/*` | `ai-rules/postman/*` | Postman artifacts (jika external dev) |
| `dev-docs/temp/` | (tanpa template -- AI scratchpad) | File sementara AI |

### Folder Output: `revamp/` (Revamp / Merger)

| File Output | Template Source | Keterangan |
|-------------|----------------|------------|
| `revamp/old-system.md` | `ai-rules/revamp-templates/old-system.md` | Audit sistem lama |
| `revamp/gap-analysis.md` | `ai-rules/revamp-templates/gap-analysis.md` | Gap old vs new |
| `revamp/migration-strategy.md` | `ai-rules/revamp-templates/migration-strategy.md` | Strategi migrasi |
| `revamp/merger-plan.md` | `ai-rules/revamp-templates/merger-plan.md` | Merger N:1 plan |
| `revamp/data-migration.md` | `ai-rules/revamp-templates/data-migration.md` | Data migration plan |

### Folder Output: `prod-docs/` (Production-ready)

| File/Folder Output | Template Source | Keterangan |
|--------------------|----------------|------------|
| `prod-docs/AGENTS.md` | `ai-rules/prod-docs-templates/AGENTS.md` | Kontrak AI di server |
| `prod-docs/README.md` | `ai-rules/prod-docs-templates/README.md` | Panduan penggunaan |
| `prod-docs/docs/*` | `ai-rules/prod-docs-templates/docs/*` | Dokumentasi teknis server |
| `prod-docs/reports-agents/*` | `ai-rules/prod-docs-templates/reports-agents/*` | Audit log + templates |

### Folder Output: `reports/` (Maintenance + Task Reports)

| File/Folder Output | Template Source | Keterangan |
|--------------------|----------------|------------|
| `reports/task/backend/YYYY-MM-DD-{task}.md` | `ai-rules/TASK_REPORT_TEMPLATE.md` | Laporan task backend |
| `reports/task/frontend/YYYY-MM-DD-{task}.md` | `ai-rules/TASK_REPORT_TEMPLATE.md` | Laporan task frontend |
| `reports/maintenance/{tahun}/KAK/*` | `ai-rules/reports-templates/README.md` | KAK maintenance |

### Skenario: Docs Migration (Existing Unstructured Docs)

| File/Folder Output | Template Source | Keterangan |
|--------------------|----------------|------------|
| `dev-docs/ai/DOCS_MIGRATION_REPORT.md` | `ai-rules/migration/_OLD_DOCS_AUDIT_TEMPLATE.md` | Laporan audit + mapping + status |
| `dev-docs/ai/START_HERE.md` | `ai-rules/dev-docs-ai-templates/START_HERE-template.md` | Diupdate dengan info migrasi |
| `backup/old-docs/` | (tanpa template — copy dari existing) | Backup semua dokumen existing |
| Semua file output lainnya | `ai-rules/planning-templates/`, `ai-rules/dev-docs-ai-templates/`, dll | Dibuat sesuai mapping konten dari old docs |

> **Panduan lengkap:** `ai-rules/migration/README.md`
> **Mapping konten:** `ai-rules/migration/_DOCS_MAPPING_TEMPLATE.md`

## Aturan Emas

1. **AI TIDAK BOLEH mengubah file apapun di `ai-rules/`** -- baca, jangan tulis
2. **AI WAJIB membuat folder output** saat pertama kali dibutuhkan (jangan tunggu diminta)
3. **AI WAJIB membaca template** dari `ai-rules/` sebelum membuat/mengupdate file output
4. **Output folder TETAP di PROJECT ROOT** -- paralel dengan `ai-rules/` dan folder kode (`apps/` untuk monolith, `backend/` + `frontend/` untuk fullstack), JANGAN dipindahkan ke dalam folder kode
5. **Jika ragu, baca ulang template di `ai-rules/`** -- template SELALU utuh
