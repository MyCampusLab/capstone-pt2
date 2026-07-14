# Testing Guide for AI Agents

> **Status:** GUIDANCE + DATA FILE — AI mengisi data testing spesifik project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Panduan agar AI agent bisa menjalankan, menulis, dan memahami test suite project.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Semua informasi yang dibutuhkan AI agent untuk menjalankan test dengan benar. Tanpa panduan ini, AI akan skip testing atau gagal setup.

**When to update:**
- Saat test framework berubah
- Saat ada test DB baru atau seed data baru
- Saat ada flaky test yang diketahui
- Saat coverage expectation berubah

---

## Test Stack

| Layer | Framework/Tool | Command |
|-------|---------------|---------|
| Unit Test | `{PHPUnit / Pest / Vitest / Jest}` | `{command}` |
| Feature/Integration | `{framework}` | `{command}` |
| Browser/E2E | `{Dusk / Playwright / Cypress}` | `{command}` |
| Lint/Static Analysis | `{PHPStan / ESLint / Laravel Pint}` | `{command}` |
| Type Check | `{TypeScript / Psalm / PHPStan}` | `{command}` |

---

## Test Environment Setup

**Jelaskan langkah setup test environment:**
- Apakah perlu test database terpisah?
- Bagaimana cara setup test database? (`{php artisan migrate --env=testing | npm run test:migrate | ...}`?)
- Apakah perlu seed data tertentu?
- File `.env.testing` — ada? Di mana lokasinya?
- Apakah ada service dependency (Redis/Mailpit/Queue) yang perlu jalan?

```bash
# Setup commands
{ perintah_setup_1 }
{ perintah_setup_2 }
```

---

## Running Tests

### All tests
```bash
{ perintah_run_all_tests }
```

### Specific test suite
```bash
{ perintah_run_spesifik_modul }
```

### Specific test file
```bash
{ perintah_run_single_file }
```

### With coverage
```bash
{ perintah_run_coverage }
```

---

## Test File Structure

| Path | What's Tested |
|------|--------------|
| `{tests/Unit}` | `{apa yang di-test}` |
| `{tests/Feature}` | `{apa yang di-test}` |
| `{tests/Browser}` | `{apa yang di-test}` |

**Naming convention:**
- File: `{NamaModul}Test.php` atau `{namaModul}.test.ts`?
- Method: `test_{deskripsi}()` atau `it('deskripsi')`?

---

## Test Patterns (How Tests are Written in This Project)

**Jelaskan pola testing yang digunakan:**
- Apakah pakai RefreshDatabase trait?
- Apakah pakai DatabaseTransactions?
- Bagaimana factory digunakan?
- Bagaimana mocking/faking (Queue, Event, HTTP)?
- Bagaimana authentication di-test (actingAs)?

**Contoh test pattern (dari codebase):**
```php
// {salin contoh test aktual dari codebase — ini membantu AI mengikuti pola yang sudah ada}
```

---

## Known Flaky Tests

| Test | File | Symptom | Workaround |
|------|------|---------|------------|
| `{nama_test}` | `{path}` | `{gejala}` | `{workaround}` |

---

## Coverage Expectations

| Area | Expected Coverage | Current | Notes |
|------|------------------|---------|-------|
| `{modul_kritis}` | `{80%}` | `{current%}` | `{catatan}` |

---

## Pre-Merge Checklist (Testing)

Sebelum merge ke `main`, AI WAJIB memastikan:
- [ ] All tests pass
- [ ] Lint pass
- [ ] Build pass (jika ada)
- [ ] Tidak ada penurunan coverage signifikan
- [ ] Flaky tests tidak muncul (re-run 2x jika perlu)
