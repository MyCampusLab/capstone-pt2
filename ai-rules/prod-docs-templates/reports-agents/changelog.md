# Audit Log — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Server:** {hostname}
> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

File ini mencatat **semua task yang dikerjakan oleh AI agent** di server ini. Setiap entry berisi ringkasan singkat task dengan link ke laporan detail.

**Format Entry:**
```markdown
| {YYYY-MM-DD HH:MM} | {AI Agent/Teknisi} | {Judul Task} | {SUCCESS/FAILED/PARTIAL} | [Detail]({YYYY-MM-DD}/{task-name}.md) |
```

---

## Recent Tasks

### 2026-06-09

| Waktu | Eksekutor | Task | Status | Laporan |
|-------|-----------|------|--------|---------|
| 10:30 | AI Agent | Initial server documentation setup | SUCCESS | [Detail](2026-06-09/initial-setup.md) |

### 2026-06-08

| Waktu | Eksekutor | Task | Status | Laporan |
|-------|-----------|------|--------|---------|
| | | | | |

### 2026-06-07

| Waktu | Eksekutor | Task | Status | Laporan |
|-------|-----------|------|--------|---------|
| | | | | |

---

## Task Statistics

### This Month (2026-06)

| Status | Count |
|--------|-------|
| SUCCESS | {count} |
| FAILED | {count} |
| PARTIAL | {count} |
| **Total** | **{total}** |

### By Executor

| Executor | Tasks | Success Rate |
|----------|-------|--------------|
| AI Agent | {count} | {%} |
| {Teknisi 1} | {count} | {%} |
| {Teknisi 2} | {count} | {%} |

---

## Archive

{Pindahkan entries lama (> 3 bulan) ke sini}

### 2026-05

| Tanggal | Eksekutor | Task | Status |
|---------|-----------|------|--------|
| | | | |

### 2026-04

| Tanggal | Eksekutor | Task | Status |
|---------|-----------|------|--------|
| | | | |

---

## Contributing

Setelah menyelesaikan task:

1. **Tambah entry** ke tabel tanggal hari ini
2. **Isi semua kolom** (waktu, eksekutor, task, status, laporan)
3. **Buat laporan detail** di folder `{YYYY-MM-DD}/{task-name}.md`
4. **Link ke laporan** dari kolom "Laporan"

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** AI Agent + DevOps Team
