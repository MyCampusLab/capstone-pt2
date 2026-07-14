# CODING_RULES

> **Status:** GUIDANCE + DATA FILE — AI mengisi aturan coding spesifik project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Aturan coding yang HARUS diikuti oleh semua AI agent di repository ini.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Setelah menganalisis codebase, ekstrak semua konvensi coding yang terlihat. Ini bukan "best practice" generik — ini adalah aturan yang SUDAH diterapkan di codebase ini.

###  Dual-Repo: Pisahkan Backend & Frontend Rules

**Lihat deklarasi project type di `PROJECT_CONTEXT.md`.**

- **Monolith** → isi semua section di bawah
- **Fullstack** → isi **Part A: Backend** (section 1-3, 5) + **Part B: Frontend** (section 4, 6, 7)

**When to update:**
- Pertama kali analisis codebase
- Saat ada perubahan konvensi
- Saat ada kesepakatan tim baru tentang coding style

---

## Part A — Backend Rules (Monolith / Fullstack Backend)

### 1) Module and Route Conventions

**Isi dengan aturan pembuatan modul dan routing:**
- Bagaimana modul diorganisir?
- Bagaimana route didefinisikan?
- Apakah ada namespace pattern?
- Apakah ada route prefix pattern?
- Apakah ada middleware assignment pattern?

---

### 2) Authorization Conventions

**Isi dengan aturan otorisasi:**
- Bagaimana permission/RBAC diimplementasikan?
- Di mana gate/policy didefinisikan?
- Bagaimana middleware auth dipasang?
- Apakah ada role hierarchy?

---

### 3) Data and Transaction Conventions

**Isi dengan aturan pengelolaan data:**
- Apakah ada DB transaction pattern?
- Bagaimana form request / validation?
- Apakah ada data transform pattern (API resource / DTO)?

---

### 4) Import Conventions

**Isi dengan aturan import/export data:**
- Bagaimana import file diproses?
- Apakah ada chunking/queueing?
- Bagaimana validasi data import?

---

## Part B — Frontend Rules (Monolith Blade / Fullstack Frontend)

### 5) UI Conventions

**Isi dengan aturan frontend:**
- Bagaimana komponen diorganisir?
- Bagaimana state management?
- Apakah ada component naming convention?
- Bagaimana CSS/styling diatur?
- **Fullstack:** bagaimana konsumsi API dari backend?

---

### 6) Testing Conventions

**Isi dengan aturan testing:**
- Framework testing: `{PHPUnit / Pest / Vitest / Jest / Playwright}`
- Di mana file test disimpan?
- Apakah ada naming convention untuk test?
- Apakah ada coverage expectation?

---

### 7) Documentation Conventions

**Isi dengan aturan dokumentasi:**
- Apakah ada PHPDoc/JSDoc requirement?
- Apakah ada changelog convention?
- **Fullstack:** di mana API contract disimpan?
