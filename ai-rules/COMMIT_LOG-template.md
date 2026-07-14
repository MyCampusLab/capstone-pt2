# COMMIT LOG — Indeks

> **Status:** INDICES — AI WAJIB mencatat setiap commit di log harian, bukan di file ini.
> **Purpose:** File ini hanya indeks. Commit detail ada di file per hari di folder `commit-logs/`.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Anti-Monster Rule + Daily Split

**DILARANG** menulis detail commit di file ini. File ini hanya **indeks**.

**Setiap hari ada file sendiri** di `commit-logs/YYYY-MM-DD.md`. AI mencatat commit di file harian yang sesuai.

| File | Isi |
|------|-----|
| `COMMIT_LOG.md` (this file) | Hanya indeks — daftar hari + link ke file harian |
| `commit-logs/YYYY-MM-DD.md` | Detail commit untuk hari itu (1 file per hari) |

###  Dual-Repo: Tanda Repo di Setiap Entry

Untuk fullstack, tiap entry commit wajib mencantumkan repo (`backend` / `frontend`). AI harus tahu repo mana yang di-commit.

### Rollback Reference

**Cara mencari commit untuk rollback:**
1. Lihat tabel indeks di bawah — cari rentang tanggal + repo
2. Buka file harian yang sesuai
3. Copy hash dari entry commit
4. Verifikasi hash: `cd {apps|backend|frontend} && git log --oneline -20`
5. Rollback: `cd {apps|backend|frontend} && git reset --hard <HASH>`

---

## Daily Index

| Date | Repo | Commits | File |
|------|------|---------|------|
| `{YYYY-MM-DD}` | `{apps / backend / frontend}` | `{jumlah commit}` | [commit-logs/{YYYY-MM-DD}.md](./commit-logs/{YYYY-MM-DD}.md) |

---

## Daily Commit Log Template

> Gunakan template ini untuk setiap file `commit-logs/YYYY-MM-DD.md`

```markdown
# Commit Log — {YYYY-MM-DD}

## {Repo: apps / backend / frontend}

| # | Time | Hash | Message | Author |
|---|------|------|---------|--------|
| 1 | {HH:MM} | {hash_7char} | {commit message} | {AI_model} |
| 2 | {HH:MM} | {hash_7char} | {commit message} | {AI_model} |

## Summary

- Total commits: {N}
- Features: {ringkasan fitur yang ditambahkan}
- Fixes: {ringkasan bug yang difixed}
- Refactors: {ringkasan refactoring}
```
