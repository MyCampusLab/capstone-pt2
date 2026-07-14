# Coding Standards untuk AI Vibe Coding

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB - Semua AI agent HARUS mengikuti standar ini
> **Purpose:** Memastikan AI menghasilkan kode yang clean, maintainable, dan profesional

---

## Coding Standards Index

| # | Section | File | Key Rules |
|---|---------|------|-----------|
| 1 | File Size Limits | [01-file-size-limits.md](./coding-standards/01-file-size-limits.md) | Controller max 1000, Service max 800, Model max 300 |
| 2 | Route Organization | [02-route-organization.md](./coding-standards/02-route-organization.md) | 1 route file = 1 module, max 200 baris |
| 3 | View/UI Organization | [03-view-ui-organization.md](./coding-standards/03-view-ui-organization.md) | Split view >500 baris, component-based |
| 4 | Separation of Concerns | [04-separation-of-concerns.md](./coding-standards/04-separation-of-concerns.md) | Controller → Service → Repository → Model |
| 5 | Framework-Specific Guidelines | [05-framework-specific-guidelines.md](./coding-standards/05-framework-specific-guidelines.md) | Laravel, Express, Go patterns |
| 6 | Anti-Patterns | [06-anti-patterns.md](./coding-standards/06-anti-patterns.md) | DILARANG God Controller, Fat Model, deep nesting |
| 7 | Refactoring Checklist | [07-refactoring-checklist.md](./coding-standards/07-refactoring-checklist.md) | Checklist sebelum commit |
| 8 | Code Review Questions | [08-code-review-questions.md](./coding-standards/08-code-review-questions.md) | Pertanyaan saat review kode |
| 9 | Tools untuk Detect Code Smells | [09-tools-detect-code-smells.md](./coding-standards/09-tools-detect-code-smells.md) | PHPStan, ESLint, gosec, dll |
| 10 | Contoh Refactoring Real-World | [10-contoh-refactoring-real-world.md](./coding-standards/10-contoh-refactoring-real-world.md) | Studi kasus refactor |
| 11 | Enforcement | [11-enforcement.md](./coding-standards/11-enforcement.md) | Kapan dan bagaimana enforce |

**WHEN TO READ WHAT:**
- **Read CODING_STANDARDS.md** → overview, pick which section to read
- **Read Section 1** → when starting new project (file size baseline)
- **Read Section 6** → when reviewing code (anti-patterns)
- **Read Section 7** → before commit (refactoring checklist)
- **Read Section 11** → when deciding enforcement policy

---

**Last Updated:** 2026-06-09  
**Version:** 1.1  
**Status:** Active
