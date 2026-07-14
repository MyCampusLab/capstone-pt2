# reports-templates/ -- Templates untuk reports/ output

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

## Struktur Output (dibuat AI di root project)

```
reports/
├── task/
│   ├── backend/
│   │   └── YYYY-MM-DD-{task}.md
│   └── frontend/
│       └── YYYY-MM-DD-{task}.md
└── maintenance/
    └── {tahun}/
        ├── KAK/
        │   └── kak-maintenance-{project}-{tahun}.md
        └── Laporan/
            ├── YYYY-MM-DD-laporan-maintenance.md
            ├── scope-{a,b,c}-{nama-scope}.md
            └── assets/png/
```

## Aturan

1. AI membuat laporan task SETELAH push berhasil
2. Format: Markdown (.md)
3. Penamaan: YYYY-MM-DD-{task-name}.md
4. Lihat TASK_REPORT_RULES.md untuk aturan lengkap
