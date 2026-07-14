# ADR 001 — Architecture Decision Record Template

> **Status:** GUIDANCE + DATA FILE — AI mengisi data keputusan, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Template ADR (Architecture Decision Record). Semua keputusan arsitektur penting HARUS dicatat dengan format ini.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Setiap kali ada keputusan arsitektur penting, catat sebagai ADR (Architecture Decision Record). Format ini standar untuk mencatat konteks, keputusan, dan konsekuensinya.

**When to create new ADR:**
- Memilih framework/library utama
- Memutuskan pola arsitektur (monolith vs microservices)
- Memutuskan strategi database (single vs multiple)
- Memutuskan pola routing/middleware
- Memutuskan strategi frontend rendering
- Setiap keputusan yang akan sulit diubah nantinya

**Naming convention:** `{NNN}-{slug-deskripsi}.md` — nomor urut, mulai dari 001.

---

## Status

`{Proposed / Accepted / Deprecated / Superseded by ADR-XXX}`

---

## Context

**Jelaskan situasi dan masalah yang mendorong keputusan ini:**
- Apa yang sedang dihadapi?
- Kenapa keputusan ini perlu dibuat sekarang?
- Apa batasan/constraint yang ada? (teknis, bisnis, waktu, tim)

---

## Decision

**Jelaskan keputusan yang diambil:**
- Apa yang diputuskan?
- Bagaimana implementasinya?
- Apa alternatif yang dipertimbangkan dan kenapa ditolak?

---

## Consequences

### Positive

- `{konsekuensi_positif_1}`
- `{konsekuensi_positif_2}`

### Trade-offs

- `{tradeoff_1}`
- `{tradeoff_2}`

### Risks

- `{risiko_1 — dan mitigasinya jika ada}`
