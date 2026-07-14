# DOCS_MIGRATION_REPORT.md — Laporan Migrasi Dokumentasi

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca template ini, lalu BUAT file output di dev-docs/ai/DOCS_MIGRATION_REPORT.md — JANGAN ubah template ini.**
>
> **Output Location:** `dev-docs/ai/` — **DI LUAR git repo. Safe untuk informasi migration internal.**

---

## 1. Migration Metadata

| Field | Value |
|-------|-------|
| Project | `{nama project}` |
| Migration Date | `{YYYY-MM-DD HH:mm}` |
| AI Model | `{model_AI}` |
| Scope | `{semua docs / specific folder}` |
| Old Docs Location | `{path ke folder/file docs existing}` |
| Backup Location | `backup/old-docs/` |

---

## 2. Audit Summary

### File Inventarisasi

| # | File Path | Tipe | Size | Konten Utama | Kualitas | Kategori |
|---|-----------|------|------|-------------|----------|----------|
| 1 | `docs/README.md` | .md | {n} KB | {deskripsi} | {baik/sedang/kurang} | {planning/dev-docs/prod-docs/reports/orphan} |
| 2 | `wiki/api-spec.md` | .md | {n} KB | {deskripsi} | {baik/sedang/kurang} | {planning/dev-docs/prod-docs/reports/orphan} |
| 3 | `{file}` | {type} | {n} KB | {deskripsi} | {baik/sedang/kurang} | {planning/dev-docs/prod-docs/reports/orphan} |

### Statistik

| Metric | Value |
|--------|-------|
| Total files found | {n} |
| Files migrated | {n} |
| Files partially migrated | {n} |
| Files skipped (not relevant) | {n} |
| Ambiguities flagged | {n} |

---

## 3. Content Mapping — Old → New

### Planning Output

| Target File | Source File(s) | Content Extracted | Missing Info |
|-------------|----------------|--------------------|--------------|
| `planning/PROJECT_BRIEF.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `planning/architecture.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `planning/database.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `planning/modules.md` | {source} | {apa yg diextract} | {apa yg kurang} |

### dev-docs/ Output

| Target File | Source File(s) | Content Extracted | Missing Info |
|-------------|----------------|--------------------|--------------|
| `dev-docs/ai/START_HERE.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/ai/PROJECT_CONTEXT.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/ai/MODULE_MAP.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/ai/CURRENT_STATE.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/architecture/*` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/modules/*` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/integrations/*` | {source} | {apa yg diextract} | {apa yg kurang} |
| `dev-docs/decisions/*` | {source} | {apa yg diextract} | {apa yg kurang} |

### prod-docs/ Output

| Target File | Source File(s) | Content Extracted | Missing Info |
|-------------|----------------|--------------------|--------------|
| `prod-docs/AGENTS.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `prod-docs/docs/architecture/overview.md` | {source} | {apa yg diextract} | {apa yg kurang} |
| `prod-docs/docs/tech-stack/*` | {source} | {apa yg diextract} | {apa yg kurang} |
| `prod-docs/docs/operations/*` | {source} | {apa yg diextract} | {apa yg kurang} |

---

## 4. Migration Status

### Checklist per Folder Output

#### planning/
- [ ] `PROJECT_BRIEF.md` — {status: done / partial / n/a}
- [ ] `prd.md` — {status}
- [ ] `architecture.md` — {status}
- [ ] `database.md` — {status}
- [ ] `modules.md` — {status}
- [ ] `api-contract.md` — {status}
- [ ] `wireframe.md` — {status}
- [ ] `timeline.md` — {status}

#### dev-docs/ai/
- [ ] `START_HERE.md` — {status}
- [ ] `PROJECT_CONTEXT.md` — {status}
- [ ] `PROJECT_MENTAL_MODEL.md` — {status}
- [ ] `MODULE_MAP.md` — {status}
- [ ] `AGENTS.md` — {status}
- [ ] `CODING_RULES.md` — {status}
- [ ] `CURRENT_STATE.md` — {status}
- [ ] `TASKS.md` — {status}
- [ ] `FINAL_SYSTEM_HANDOVER.md` — {status}
- [ ] `TECHNICAL_DEBT.md` — {status}
- [ ] `KNOWN_ISSUES.md` — {status}
- [ ] `VERSION.md` — {status}

#### dev-docs/architecture/
- [ ] `api-flow.md` — {status}
- [ ] `backend-structure.md` — {status}
- [ ] `database.md` — {status}
- [ ] `frontend-structure.md` — {status}

#### dev-docs/modules/
- [ ] `{modul_a}/` — {status}
- [ ] `{modul_b}/` — {status}

#### dev-docs/integrations/
- [ ] `{service_a}.md` — {status}

#### prod-docs/
- [ ] `AGENTS.md` — {status}
- [ ] `docs/architecture/overview.md` — {status}
- [ ] `docs/tech-stack/*` — {status}
- [ ] `docs/operations/*` — {status}

---

## 5. Gaps & Ambiguities

Content yang tidak bisa dipastikan dan butuh klarifikasi dari human developer:

| # | File Target | Section | Issue | Pertanyaan ke User |
|---|-------------|---------|-------|--------------------|
| 1 | `{file}` | `{section}` | `{deskripsi ambiguity}` | `{pertanyaan spesifik}` |

### Orphan Content

Content dari old docs yang tidak bisa di-mapping ke folder output manapun:

| # | Source | Content Summary | Saran |
|---|--------|----------------|-------|
| 1 | `{file}` | `{ringkasan}` | `{saran: simpan di backup / buat file baru / minta user clarify}` |

---

## 6. Backup Info

| Field | Value |
|-------|-------|
| Backup Path | `backup/old-docs/` |
| Original Location | `{path asli old docs}` |
| Backup Created | `{YYYY-MM-DD HH:mm}` |
| Status | Complete |

**Old docs masih ada di lokasi asli.** Folder `backup/old-docs/` adalah copy tambahan untuk safety.

---

## 7. Next Steps After Migration

1. **Review oleh human:** user review DOCS_MIGRATION_REPORT.md dan file output yang sudah dibuat
2. **Clarify ambiguities:** user jawab pertanyaan di section 5
3. **Fill gaps:** AI isi bagian yang masih kosong setelah mendapat jawaban dari user
4. **Remove old docs (opsional):** setelah verifikasi, user bisa menghapus folder docs existing (atau biarkan di backup)
5. **Lanjut development:** setelah dokumentasi terstruktur, AI bisa mulai kerja sesuai skenario normal
