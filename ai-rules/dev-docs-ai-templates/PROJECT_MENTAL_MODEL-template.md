# PROJECT_MENTAL_MODEL

> **Status:** GUIDANCE + DATA FILE — AI mengisi data project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Panduan konseptual — cara berpikir tentang codebase ini (bukan daftar file, tapi pola pikir).

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Ini bukan dokumentasi teknis biasa. Ini adalah "mental model" — cara berpikir yang harus dimiliki engineer/AI agent untuk memahami codebase. Jelaskan pola, filosofi, dan "mengapa"-nya, bukan "apa"-nya.

**When to update:**
- Pertama kali analisis codebase
- Saat pola arsitektur fundamental berubah
- Saat arah produk berubah signifikan

**Format:** Naratif per section, bukan tabel. Jelaskan seperti sedang mengajarkan junior developer.

---

## How to Think About This Codebase

**Jelaskan filosofi utama codebase ini. Contoh:**
- "Ini adalah modular monolith — kode dipecah per domain bisnis tapi tetap satu deployable unit."
- "Setiap modul punya route group sendiri, middleware RBAC sendiri, dan controller sendiri."
- "Jangan berpikir dalam 'file', berpikirlah dalam 'module boundary'."

---

## 1) Architecture Pattern

**Jelaskan pola arsitektur dominan:**
- Modular monolith / microservices / layered architecture?
- Bagaimana modul berkomunikasi satu sama lain?
- Apakah ada shared kernel?
- Service layer pattern atau controller-centric?

---

## 2) Request Execution Pattern

**Jelaskan bagaimana satu HTTP request diproses dari awal sampai akhir:**
- Middleware apa yang dijalankan?
- Bagaimana routing bekerja?
- Di mana validasi terjadi?
- Di mana otorisasi dicek?
- Di mana business logic berada?
- Bagaimana response dibentuk?

---

## 3) UI Pattern

**Jelaskan pola frontend:**
- Rendering model (SSR / SPA / Hybrid)?
- Bagaimana layout disusun?
- Bagaimana komponen diorganisir?
- Bagaimana state management?
- Bagaimana komunikasi dengan backend?

---

## 4) Data Migration/Import Mindset

**Jika relevan — jelaskan pola data migration/import:**
- Apakah ada pipeline ETL?
- Bagaimana data dari sistem legacy dimigrasi?
- Apakah ada dual-write period?

---

## 5) Risk Hotspots

**Jelaskan area kode yang paling berisiko:**
- Modul mana yang paling kompleks?
- Di mana bug paling sering muncul?
- Area mana yang punya dampak terbesar jika berubah?
- Di mana test coverage paling rendah?

---

## 6) Current Product Direction

**Jelaskan arah produk saat ini:**
- Apa yang sedang dibangun/diperbaiki?
- Apa milestone terdekat?
- Apakah ada pivot atau perubahan besar yang sedang terjadi?
